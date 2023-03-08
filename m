Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF216B0342
	for <lists+live-patching@lfdr.de>; Wed,  8 Mar 2023 10:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjCHJnV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 8 Mar 2023 04:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjCHJmn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 8 Mar 2023 04:42:43 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4DFB56D9;
        Wed,  8 Mar 2023 01:42:08 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id g3so14710000wri.6;
        Wed, 08 Mar 2023 01:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678268527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AJBgIU7Xesnsj5smtj9c/Sr+S22ime0DjlurEiwlbiQ=;
        b=HtLn703HG3wl6YM2ghwSnTqb14zTAOCeT0Tt6soMa8HkvGgOWk42AhC9So4MNbyF01
         5Dm3yo8vGWGHKIqAmU0OoWIEL8Lw/NlxcJWPZH8RytcZlSPKxWCGEfwc3AuzC+pyngB8
         ctldJ7eLFYaFl10FAGeGwHKD1GdkKL9mMh6BrcaB6H0HCV393TKbCKuX0caC0qrsnOTZ
         F71VNyvo4Hcbs1YP7wlkDzSKIRaYcgq8eS4Gpp/9L9fTD8s/oFLRj6xB6JsLS8xm53vc
         tuWm7AUk8gdi/pRykD3KHfxso1izUfwK1XAGRf86dnyOKed3GQq+71L1RGwbOmuubjkI
         2vKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678268527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJBgIU7Xesnsj5smtj9c/Sr+S22ime0DjlurEiwlbiQ=;
        b=etdgDI8Jrlt6J7PQk8yhRK73fOil3806NGc3BUmb838cVeC3AB2gTSOAyKh9M1gMWW
         9QpMjJG/bbVzISks1q1drNjymqukx/KOz3MGAgj3MKNaFI4u5A4tH+mYMZ4WIUXpa1xE
         YlNN5yeFHHe+1AeD/UpVoJsghB1Ts21d8TqEqHcAsdPLdXz6XSflVaOyekD+8GeBGQpm
         3oSmnNWdrIbDfYZBJnbl1rBL3wg7JQxnbU2letVUcE0laVPs3sEO6cHhEMn2/4j3Q6M1
         +/oseeG4V1Rv+rytnx1Y6BAw4WJBIwLxdZ8Mg/u+s8ai83I+MSsllJndKZgK8zHnyO75
         NE+w==
X-Gm-Message-State: AO0yUKUNtxNzY/bnRwRm4bm0mUlBSZ9c/7pt1jBJh2ipWDel/BBG1YBb
        igeNemJLEOIyXz3S7oNA17g=
X-Google-Smtp-Source: AK7set+tXIoBgWPW5Yrg9118FR7KVbCCUzBGLd9XTJclU1t4+dI6BEdoc6Rt5mZ05cXxZx3MsFOYVQ==
X-Received: by 2002:a5d:544b:0:b0:2c7:cdd:1403 with SMTP id w11-20020a5d544b000000b002c70cdd1403mr10152630wrv.55.1678268526753;
        Wed, 08 Mar 2023 01:42:06 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id m18-20020a05600c3b1200b003db0ad636d1sm20859790wms.28.2023.03.08.01.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 01:42:06 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 8 Mar 2023 10:42:04 +0100
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH] kallsyms: Delete an unused parameter related to
 {module_}kallsyms_on_each_symbol()
Message-ID: <ZAhYbEtFqwts6OxN@krava>
References: <20230308073846.1882-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308073846.1882-1-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Mar 08, 2023 at 03:38:46PM +0800, Zhen Lei wrote:
> The parameter 'struct module *' in the hook function associated with
> {module_}kallsyms_on_each_symbol() is no longer used. Delete it.
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

lgtm

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka

> ---
>  include/linux/kallsyms.h   | 7 +++----
>  include/linux/module.h     | 6 ++----
>  kernel/kallsyms.c          | 5 ++---
>  kernel/kallsyms_selftest.c | 6 +++---
>  kernel/livepatch/core.c    | 3 +--
>  kernel/module/kallsyms.c   | 5 ++---
>  kernel/trace/ftrace.c      | 3 +--
>  7 files changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> index 0065209cc00424b..fe3c9993b5bfe47 100644
> --- a/include/linux/kallsyms.h
> +++ b/include/linux/kallsyms.h
> @@ -67,8 +67,7 @@ static inline void *dereference_symbol_descriptor(void *ptr)
>  
>  #ifdef CONFIG_KALLSYMS
>  unsigned long kallsyms_sym_address(int idx);
> -int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
> -				      unsigned long),
> +int kallsyms_on_each_symbol(int (*fn)(void *, const char *, unsigned long),
>  			    void *data);
>  int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
>  				  const char *name, void *data);
> @@ -166,8 +165,8 @@ static inline bool kallsyms_show_value(const struct cred *cred)
>  	return false;
>  }
>  
> -static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
> -					  unsigned long), void *data)
> +static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *, unsigned long),
> +					  void *data)
>  {
>  	return -EOPNOTSUPP;
>  }
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 4435ad9439abba6..1de304e0b09c7f9 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -888,13 +888,11 @@ static inline bool module_sig_ok(struct module *module)
>  
>  #if defined(CONFIG_MODULES) && defined(CONFIG_KALLSYMS)
>  int module_kallsyms_on_each_symbol(const char *modname,
> -				   int (*fn)(void *, const char *,
> -					     struct module *, unsigned long),
> +				   int (*fn)(void *, const char *, unsigned long),
>  				   void *data);
>  #else
>  static inline int module_kallsyms_on_each_symbol(const char *modname,
> -						 int (*fn)(void *, const char *,
> -						 struct module *, unsigned long),
> +						 int (*fn)(void *, const char *, unsigned long),
>  						 void *data)
>  {
>  	return -EOPNOTSUPP;
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 83f499182c9aa31..77747391f49b66c 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -288,8 +288,7 @@ unsigned long kallsyms_lookup_name(const char *name)
>   * Iterate over all symbols in vmlinux.  For symbols from modules use
>   * module_kallsyms_on_each_symbol instead.
>   */
> -int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
> -				      unsigned long),
> +int kallsyms_on_each_symbol(int (*fn)(void *, const char *, unsigned long),
>  			    void *data)
>  {
>  	char namebuf[KSYM_NAME_LEN];
> @@ -299,7 +298,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>  
>  	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
>  		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
> -		ret = fn(data, namebuf, NULL, kallsyms_sym_address(i));
> +		ret = fn(data, namebuf, kallsyms_sym_address(i));
>  		if (ret != 0)
>  			return ret;
>  		cond_resched();
> diff --git a/kernel/kallsyms_selftest.c b/kernel/kallsyms_selftest.c
> index bfbc12da33267f8..a2e3745d15c471f 100644
> --- a/kernel/kallsyms_selftest.c
> +++ b/kernel/kallsyms_selftest.c
> @@ -95,7 +95,7 @@ static struct test_item test_items[] = {
>  
>  static char stub_name[KSYM_NAME_LEN];
>  
> -static int stat_symbol_len(void *data, const char *name, struct module *mod, unsigned long addr)
> +static int stat_symbol_len(void *data, const char *name, unsigned long addr)
>  {
>  	*(u32 *)data += strlen(name);
>  
> @@ -154,7 +154,7 @@ static void test_kallsyms_compression_ratio(void)
>  	pr_info(" ---------------------------------------------------------\n");
>  }
>  
> -static int lookup_name(void *data, const char *name, struct module *mod, unsigned long addr)
> +static int lookup_name(void *data, const char *name, unsigned long addr)
>  {
>  	u64 t0, t1, t;
>  	struct test_stat *stat = (struct test_stat *)data;
> @@ -207,7 +207,7 @@ static bool match_cleanup_name(const char *s, const char *name)
>  	return !strncmp(s, name, len);
>  }
>  
> -static int find_symbol(void *data, const char *name, struct module *mod, unsigned long addr)
> +static int find_symbol(void *data, const char *name, unsigned long addr)
>  {
>  	struct test_stat *stat = (struct test_stat *)data;
>  
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 4bd2d5e10f20a1c..1de2c40cc37841a 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -142,8 +142,7 @@ static int klp_match_callback(void *data, unsigned long addr)
>  	return 0;
>  }
>  
> -static int klp_find_callback(void *data, const char *name,
> -			     struct module *mod, unsigned long addr)
> +static int klp_find_callback(void *data, const char *name, unsigned long addr)
>  {
>  	struct klp_find_arg *args = data;
>  
> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
> index ab2376a1be88e7e..c4fe856e5052ff7 100644
> --- a/kernel/module/kallsyms.c
> +++ b/kernel/module/kallsyms.c
> @@ -495,8 +495,7 @@ unsigned long module_kallsyms_lookup_name(const char *name)
>  }
>  
>  int module_kallsyms_on_each_symbol(const char *modname,
> -				   int (*fn)(void *, const char *,
> -					     struct module *, unsigned long),
> +				   int (*fn)(void *, const char *, unsigned long),
>  				   void *data)
>  {
>  	struct module *mod;
> @@ -525,7 +524,7 @@ int module_kallsyms_on_each_symbol(const char *modname,
>  				continue;
>  
>  			ret = fn(data, kallsyms_symbol_name(kallsyms, i),
> -				 mod, kallsyms_symbol_value(sym));
> +				 kallsyms_symbol_value(sym));
>  			if (ret != 0)
>  				goto out;
>  		}
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 29baa97d0d53428..76caca8f496aaed 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -8391,8 +8391,7 @@ struct kallsyms_data {
>   * and returns 1 in case we resolved all the requested symbols,
>   * 0 otherwise.
>   */
> -static int kallsyms_callback(void *data, const char *name,
> -			     struct module *mod, unsigned long addr)
> +static int kallsyms_callback(void *data, const char *name, unsigned long addr)
>  {
>  	struct kallsyms_data *args = data;
>  	const char **sym;
> -- 
> 2.25.1
> 
