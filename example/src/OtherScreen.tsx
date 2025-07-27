import { Alert, Button, StyleSheet, Text, View } from 'react-native';
import { type FC } from 'react';

const OtherScreen: FC = () => {
  return (
    <View style={styles.container}>
      <Text>📄 Others screen</Text>
      <Button title="Show Alert" onPress={() => Alert.alert('Hello World')} />
    </View>
  );
};

export default OtherScreen;

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', alignItems: 'center' },
});
