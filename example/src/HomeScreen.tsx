import { useEffect, useState, type FC } from 'react';
import { View, StyleSheet, Button, Text } from 'react-native';
import {
  getIcon,
  changeIcon,
  changeIconSilently,
} from '@linhlm23496/react-native-change-app-icon';
import { useNavigation } from '@react-navigation/native';

const HomeScreen: FC = () => {
  const navigation = useNavigation();
  const [currentIcon, setCurrentIcon] = useState<string>('');

  useEffect(() => {
    onGetIcon();
  }, []);

  async function onChangeIcon(iconName?: string) {
    try {
      await changeIcon(iconName);
    } finally {
      onGetIcon();
    }
  }

  async function onChangeIconSilent(iconName?: string) {
    try {
      await changeIconSilently(iconName);
    } finally {
      onGetIcon();
    }
  }

  async function onGetIcon() {
    const icon = await getIcon();
    setCurrentIcon(icon);
  }

  return (
    <View style={styles.container}>
      <Text style={styles.text}>{currentIcon}</Text>
      <Button title="Get current Icon" onPress={onGetIcon} />
      <Button title="Change Icon Default" onPress={() => onChangeIcon()} />
      <Button
        title="Change Icon XSquare"
        onPress={() => onChangeIcon('XSquare')}
      />
      <Button
        title="Change Icon PlusSquare"
        onPress={() => onChangeIcon('PlusSquare')}
      />
      <Button
        title="Change Icon Silent Default"
        onPress={() => onChangeIconSilent()}
      />
      <Button
        title="Change Icon Silent XSquare"
        onPress={() => onChangeIconSilent('XSquare')}
      />
      <Button
        title="Change Icon Silent PlusSquare"
        onPress={() => onChangeIconSilent('PlusSquare')}
      />
      <Button title="Change Icon Any" onPress={() => onChangeIcon('Any')} />
      <Button
        title="Navigate to Other"
        onPress={() => {
          //@ts-ignore
          navigation.navigate('Other');
        }}
      />
    </View>
  );
};

export default HomeScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 16,
  },
  text: {
    fontSize: 24,
  },
});
