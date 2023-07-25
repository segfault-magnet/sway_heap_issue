#[cfg(test)]
mod tests {
    

    use fuels::{
        prelude::{setup_program_test, *},
        types::Bits256,
    };

    

    #[tokio::test]
    async fn shows_revert_happened_after_allocation() {
        setup_program_test!(
            Wallets("wallet"),
            Abigen(
                Contract(name = "MyContract", project = "contract"),
                Script(name = "MyScript", project = "script")
            ),
            Deploy(
                name = "contract_instance",
                contract = "MyContract",
                wallet = "wallet"
            ),
            LoadScript(
                name = "script_instance",
                script = "MyScript",
                wallet = "wallet"
            )
        );

        let contract_id = Bits256(*contract_instance.contract_id().hash());
        let script_config = MyScriptConfigurables::new().set_CONTRACT_ID(contract_id);

        let result = script_instance
            .with_configurables(script_config)
            .main()
            .set_contracts(&[&contract_instance])
            .call()
            .await;

        if let Err(Error::RevertTransactionError { reason, .. }) = result {
            assert_eq!(
                reason,
                r#"SizedAsciiString { data: "Vec first element got corrupted after" }"#
            );
        } else {
            panic!("Should have failed with revert error");
        }
    }
}
