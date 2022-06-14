Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA6A54B13B
	for <lists+live-patching@lfdr.de>; Tue, 14 Jun 2022 14:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbiFNMbT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Jun 2022 08:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245049AbiFNM24 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Jun 2022 08:28:56 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C267E23165;
        Tue, 14 Jun 2022 05:28:53 -0700 (PDT)
Received: from [192.168.1.133] (unknown [112.20.110.105])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxX07zfqhiLj5BAA--.3602S3;
        Tue, 14 Jun 2022 20:28:39 +0800 (CST)
Subject: Re: [PATCH] doc: module: update file references
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Alex Shi <alexs@kernel.org>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthias Maennich <maennich@google.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220613081741.1699713-1-masahiroy@kernel.org>
From:   Yanteng Si <siyanteng@loongson.cn>
Message-ID: <027dcfc9-be47-5fb5-7ea8-26eb19122095@loongson.cn>
Date:   Tue, 14 Jun 2022 20:28:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220613081741.1699713-1-masahiroy@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxX07zfqhiLj5BAA--.3602S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Gw18urW8WF45Gr4fGFy3Jwb_yoWxWw1fpa
        s2kryfXan7JryUCw18Wr12gF17GFyxWF4DW3Z5Jwn3ZFn8AFy0yF47tr9Y9a4jgry0yFW8
        XF4xtFyjy34jvrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9mb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l
        c7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_Xr1l42xK82IYc2Ij64vIr41l4I8I3I
        0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
        GVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
        0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0
        rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
        0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07bOXd8UUUUU=
X-CM-SenderInfo: pvl1t0pwhqwqxorr0wxvrqhubq/
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 2022/6/13 下午4:17, Masahiro Yamada wrote:
> Adjust documents to the file moves made by commit cfc1d277891e ("module:
> Move all into module/").
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Yanteng Si <siyanteng@loongson.cn>
> ---
> 
> I did not touch
> 
>    Documentation/translations/zh_CN/core-api/kernel-api.rst
diff --git a/Documentation/translations/zh_CN/core-api/kernel-api.rst 
b/Documentation/translations/zh_CN/core-api/kernel-api.rst
index e45fe80d1cd8..962d31d019d7 100644
--- a/Documentation/translations/zh_CN/core-api/kernel-api.rst
+++ b/Documentation/translations/zh_CN/core-api/kernel-api.rst
@@ -224,7 +224,7 @@ kernel/kmod.c
  模块接口支持
  ------------

-更多信息请参考文件kernel/module.c。
+更多信息请参阅kernel/module/目录下的文件。

  硬件接口
  ========

> 
> because I cannot modify it.Let me help you, it's my pleasure.  :)

Thanks,
Yanteng
> 
>   Documentation/core-api/kernel-api.rst                  |  2 +-
>   Documentation/core-api/symbol-namespaces.rst           |  4 ++--
>   Documentation/livepatch/module-elf-format.rst          | 10 +++++-----
>   .../translations/it_IT/core-api/symbol-namespaces.rst  |  6 +++---
>   .../translations/zh_CN/core-api/symbol-namespaces.rst  |  2 +-
>   5 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/core-api/kernel-api.rst b/Documentation/core-api/kernel-api.rst
> index d6b3f94b9f1f..0793c400d4b0 100644
> --- a/Documentation/core-api/kernel-api.rst
> +++ b/Documentation/core-api/kernel-api.rst
> @@ -223,7 +223,7 @@ Module Loading
>   Inter Module support
>   --------------------
>   
> -Refer to the file kernel/module.c for more information.
> +Refer to the files in kernel/module/ for more information.
>   
>   Hardware Interfaces
>   ===================
> diff --git a/Documentation/core-api/symbol-namespaces.rst b/Documentation/core-api/symbol-namespaces.rst
> index 5ad9e0abe42c..12e4aecdae94 100644
> --- a/Documentation/core-api/symbol-namespaces.rst
> +++ b/Documentation/core-api/symbol-namespaces.rst
> @@ -51,8 +51,8 @@ namespace ``USB_STORAGE``, use::
>   The corresponding ksymtab entry struct ``kernel_symbol`` will have the member
>   ``namespace`` set accordingly. A symbol that is exported without a namespace will
>   refer to ``NULL``. There is no default namespace if none is defined. ``modpost``
> -and kernel/module.c make use the namespace at build time or module load time,
> -respectively.
> +and kernel/module/main.c make use the namespace at build time or module load
> +time, respectively.
>   
>   2.2 Using the DEFAULT_SYMBOL_NAMESPACE define
>   =============================================
> diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
> index dbe9b400e39f..7347638895a0 100644
> --- a/Documentation/livepatch/module-elf-format.rst
> +++ b/Documentation/livepatch/module-elf-format.rst
> @@ -210,11 +210,11 @@ module->symtab.
>   =====================================
>   Normally, a stripped down copy of a module's symbol table (containing only
>   "core" symbols) is made available through module->symtab (See layout_symtab()
> -in kernel/module.c). For livepatch modules, the symbol table copied into memory
> -on module load must be exactly the same as the symbol table produced when the
> -patch module was compiled. This is because the relocations in each livepatch
> -relocation section refer to their respective symbols with their symbol indices,
> -and the original symbol indices (and thus the symtab ordering) must be
> +in kernel/module/kallsyms.c). For livepatch modules, the symbol table copied
> +into memory on module load must be exactly the same as the symbol table produced
> +when the patch module was compiled. This is because the relocations in each
> +livepatch relocation section refer to their respective symbols with their symbol
> +indices, and the original symbol indices (and thus the symtab ordering) must be
>   preserved in order for apply_relocate_add() to find the right symbol.
>   
>   For example, take this particular rela from a livepatch module:::
> diff --git a/Documentation/translations/it_IT/core-api/symbol-namespaces.rst b/Documentation/translations/it_IT/core-api/symbol-namespaces.rst
> index 42f5d04e38ec..0f6898860d6d 100644
> --- a/Documentation/translations/it_IT/core-api/symbol-namespaces.rst
> +++ b/Documentation/translations/it_IT/core-api/symbol-namespaces.rst
> @@ -50,9 +50,9 @@ Di conseguenza, nella tabella dei simboli del kernel ci sarà una voce
>   rappresentata dalla struttura ``kernel_symbol`` che avrà il campo
>   ``namespace`` (spazio dei nomi) impostato. Un simbolo esportato senza uno spazio
>   dei nomi avrà questo campo impostato a ``NULL``. Non esiste uno spazio dei nomi
> -di base. Il programma ``modpost`` e il codice in kernel/module.c usano lo spazio
> -dei nomi, rispettivamente, durante la compilazione e durante il caricamento
> -di un modulo.
> +di base. Il programma ``modpost`` e il codice in kernel/module/main.c usano lo
> +spazio dei nomi, rispettivamente, durante la compilazione e durante il
> +caricamento di un modulo.
>   
>   2.2 Usare il simbolo di preprocessore DEFAULT_SYMBOL_NAMESPACE
>   ==============================================================
> diff --git a/Documentation/translations/zh_CN/core-api/symbol-namespaces.rst b/Documentation/translations/zh_CN/core-api/symbol-namespaces.rst
> index 6abf7ed534ca..bb16f0611046 100644
> --- a/Documentation/translations/zh_CN/core-api/symbol-namespaces.rst
> +++ b/Documentation/translations/zh_CN/core-api/symbol-namespaces.rst
> @@ -52,7 +52,7 @@
>   
>   相应的 ksymtab 条目结构体 ``kernel_symbol`` 将有相应的成员 ``命名空间`` 集。
>   导出时未指明命名空间的符号将指向 ``NULL`` 。如果没有定义命名空间，则默认没有。
> -``modpost`` 和kernel/module.c分别在构建时或模块加载时使用名称空间。
> +``modpost`` 和kernel/module/main.c分别在构建时或模块加载时使用名称空间。
>   
>   2.2 使用DEFAULT_SYMBOL_NAMESPACE定义
>   ====================================
> 

