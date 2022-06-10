#!/bin/bash

runit() {
	test_name="$1"
	test_dir="${test_name}_results"
	mkdir "$test_dir" -p
	echo "Cleaning 'out' dirs and 'Forc.lock's"
	find . -type d -name "out" | xargs rm -rf 
	find . -type d -name "Forc.lock" | xargs rm -f

	echo "Running fuel-core"
	fuel-core --db-type in-memory &> /dev/null &
	fuel_core_pid="$!"
	sleep 1

	pushd contract &> /dev/null
	echo "Building and deploying contract"
	contract_id="$(forc deploy | grep 'Contract id: ' | cut -d: -f2- | sed 's/^\s*//g')"
	popd &> /dev/null

	pushd script &> /dev/null

	echo "Running script"

	sed -i "s/CONTRACT_ID/$contract_id/g" "src/main.sw"
	script_output="$(forc run --contract "$contract_id" | grep 'Bytecode size is' -A 1 | tail -1 | jq)"
	sed -i "s/$contract_id/CONTRACT_ID/g" "src/main.sw"

	popd &> /dev/null

	echo "Saving script output and contract binary"

	echo "$script_output"  > "$test_dir/script_output.json"
	jq '.[1].ReturnData.data' -r <<< "$script_output" > "$test_dir/script_output_only_data.txt"
	mv contract/out/debug "$test_dir/compiled"

	echo "Killing fuel core"
	kill -9 "$fuel_core_pid"
}


echo "Uninstalling the current version of forc"
cargo uninstall forc

echo "Installing forc 0.14.5 via cargo"
cargo install forc --version 0.14.5

runit "forc_from_cargo_0.14.5"

echo "Uninstalling the current version of forc"
cargo uninstall forc

echo "Installing forc 0.15.1 via cargo"
cargo install forc --version 0.15.1

runit "forc_from_cargo_0.15.1"

echo "Uninstalling the current version of forc"
cargo uninstall forc

echo "Installing forc 0.15.1 via curl"
curl -sSLf https://github.com/FuelLabs/sway/releases/download/v0.15.1/forc-binaries-linux_amd64.tar.gz -L | tar xz 
mv forc-binaries/forc ~/.cargo/bin/forc
rm -rf "forc-binaries"

runit "forc_from_curl_0.15.1"
rm ~/.cargo/bin/forc

echo "Installing forc 0.15.2 via cargo"
cargo install forc --version 0.15.2

runit "forc_from_cargo_0.15.2"

