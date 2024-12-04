import os
import asyncio
from openai import AsyncOpenAI

TARGET_LANGUAGES = os.environ.get('TARGET_LANGUAGES').split(',')
GPT_MODE = os.environ.get('GPT_MODE', 'gpt-4o-mini')

LANGUAGES_MAPPER = {
    'ja': 'Japanese',
    'zh-hans': 'Simplified Chinese',
    'zh-hant': 'Traditional Chinese',
    'pt-br': 'Portuguese (Brazil)',
    'es': 'Spanish',
    'ar': 'Arabic',
    'hi': 'Hindi',
    'bn': 'Bengali',
    'fr': 'French',
    'ru': 'Russian',
    'pt': 'Portuguese',
    'de': 'German',
    'ko': 'Korean',
    'vi': 'Vietnamese',
    'it': 'Italian',
    'tr': 'Turkish',
    'fa': 'Persian',
    'ur': 'Urdu',
    'th': 'Thai',
    'ta': 'Tamil'
}


class OpenAITranslate:
    def __init__(self, key: str | None = None, base_url: str | None = None):
        self.client = AsyncOpenAI(api_key=key, base_url=base_url)

    async def translate_md(self, text, target_lang="English", model='gpt-4o-mini') -> str | None:
        prompt = f"""
           Translate the following markdown context to [{target_lang}],
           adhere to the following rules:\n
           1. Maintain the original format, symbols, and spacing of the text.\n 
           2. Only provide me with the translated text result, without any descriptions.\n
           3. Translate all the content of the text accurately, preserving line breaks.\n
           4. Display all punctuation marks and parentheses in half-width characters.\n
           5. Avoid translate the text in code block or inline code.\n
           6. Avoid using the ```markdown ``` code block notation.\n
           Output the result in 'markdown code' format:\n
        """
        try:
            response = await self.client.chat.completions.create(
                messages=[
                    {"role": "system", "content": prompt},
                    {"role": "user", "content": text},
                ],
                model=model
            )
        except Exception as e:
            print("Open AI Error: ", e)
            return
        return response.choices[0].message.content.strip()


def read_readme():
    with open('./README.md', 'r', encoding='utf-8') as f:
        print('Read from:', './README.md')
        content = f.read()
        return content


async def translate(content, target_lang):
    t = OpenAITranslate()
    try:
        translated = await t.translate_md(content, target_lang, GPT_MODE)
        return translated
    except Exception as e:
        print('Translate Error:', e)


def write_readme(content, lang_code):
    if not content:
        print('Empty content, skip write. {}'.format(lang_code))
        return
    filename = f'./readmes/README.{lang_code}.md'
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, 'w', encoding='utf-8') as f:
        print('Write to:', filename)
        f.write(content)


async def main():
    source_readme = read_readme()
    for lang_code in TARGET_LANGUAGES:
        lang = LANGUAGES_MAPPER.get(lang_code, lang_code)
        translated_readme = await translate(source_readme, lang)
        write_readme(translated_readme, lang_code)


if __name__ == '__main__':
    asyncio.run(main())
