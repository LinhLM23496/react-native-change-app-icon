import { useEffect, useState } from 'react';
import { View, StyleSheet, Button, Text } from 'react-native';
import {
  getIcon,
  changeIcon,
  changeIconSilently,
} from 'react-native-change-app-icon';

export default function App() {
  const [currentIcon, setCurrentIcon] = useState<string>('');

  useEffect(() => {
    onGetIcon();
  }, []);

  async function onChangeIcon(iconName?: string) {
    if (iconName === (await getIcon())) return;
    try {
      await changeIcon(iconName);
    } finally {
      onGetIcon();
    }
  }

  async function onChangeIconSilent(iconName?: string) {
    if (iconName === (await getIcon())) return;
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
      <Button title="Change Icon AppIcon" onPress={() => onChangeIcon()} />
      <Button
        title="Change Icon Custom2"
        onPress={() => onChangeIcon('AppIconCustom2')}
      />
      <Button
        title="Change Icon Custom3"
        onPress={() => onChangeIcon('AppIconCustom3')}
      />
      <Button
        title="Change Icon Silent AppIcon"
        onPress={() => onChangeIconSilent()}
      />
      <Button
        title="Change Icon Silent Custom2"
        onPress={() => onChangeIconSilent('AppIconCustom2')}
      />
      <Button
        title="Change Icon Silent Custom3"
        onPress={() => onChangeIconSilent('AppIconCustom3')}
      />
      <Button title="Change Icon Any" onPress={() => onChangeIcon('Any')} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  text: {
    fontSize: 24,
  },
});
