Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8C34B2BF0
	for <lists+live-patching@lfdr.de>; Fri, 11 Feb 2022 18:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352241AbiBKRll (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 11 Feb 2022 12:41:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350879AbiBKRll (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 11 Feb 2022 12:41:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64BD6C6B
        for <live-patching@vger.kernel.org>; Fri, 11 Feb 2022 09:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644601298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DsslKcWWZw1ZEXjoK3NOAcTJ9ntP6kaMA/aNOxKWKsA=;
        b=UdEf2vRp6YBaFDsxA7p3QQhiK+u/+E80YCkmISYBpbL/19lRzqkjcaihB5NQZh4/LZLHlj
        cXvolKmSNPQEXqSmFDlRgeB6wf4+LKZTnFujMHY3sWleAuBLRgI2cORvx8g4BZguE0uYNV
        lSm+UrmjXU6UO8UUTMStP+CJv9t9Sbg=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-Dm9IkWYpPSey5iU4DcFSdA-1; Fri, 11 Feb 2022 12:41:37 -0500
X-MC-Unique: Dm9IkWYpPSey5iU4DcFSdA-1
Received: by mail-oo1-f72.google.com with SMTP id k16-20020a4aa5d0000000b002eaa82bf180so6115516oom.0
        for <live-patching@vger.kernel.org>; Fri, 11 Feb 2022 09:41:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DsslKcWWZw1ZEXjoK3NOAcTJ9ntP6kaMA/aNOxKWKsA=;
        b=Y/3B0ZlY9kXqukWPTAPoSkWNOguVkZqATxZiWSv+dz1JPfsfvRw+bOiKnuzDk0XYP+
         q41aCVrjg3gk7KrW0q7IUV9cHDwy0KRKMcn3e+puDlvS+8LTRbT+yHRJ7r3T+WtLC71g
         Eu0GVfxRDun3J31QKbltITaHCVYV3cJRKKa3e4uLj8cabhAVu1Nopi8RYTB3vVqWdqWQ
         sxctSDvm/8mP2HvndoyVIH8zZpvHS7Puz75fkIYpKtqKFtccoiUSVAddMw21IAEMiXC+
         MpagH6O7IDKvLJxCvg/b46nOijQqxNldmX88r7pWQMo9NgXOKHKbd/4UmV2pWyTft54M
         cKBg==
X-Gm-Message-State: AOAM531mrQG0VRvQlTDW/l2ZfAapPGRSO0eovO03jIPk+0+tkpdK+XvC
        S95Aj+9020vytTfWtLwZsj2Zc628n+kYg6GQKzHknlPG6FVSU2Q8K2YTtOOUuqtigfbuM9jHNaW
        OEoAlujQAodyGd6vz4LupLOShvw==
X-Received: by 2002:a4a:c803:: with SMTP id s3mr962361ooq.12.1644601296296;
        Fri, 11 Feb 2022 09:41:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7xm9RS9Cg53scRBXEPeV5dlBglzJkb0Owt5LpyK2WIvJG9HWSL4pe7TqN1DSUSb+3hY9s4g==
X-Received: by 2002:a4a:c803:: with SMTP id s3mr962335ooq.12.1644601296044;
        Fri, 11 Feb 2022 09:41:36 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::35])
        by smtp.gmail.com with ESMTPSA id l4sm9620481otq.50.2022.02.11.09.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 09:41:35 -0800 (PST)
Date:   Fri, 11 Feb 2022 09:41:30 -0800
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     linux-hardening@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Bruce Schlobohm <bruce.schlobohm@intel.com>,
        Jessica Yu <jeyu@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Marios Pomonis <pomonis@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Nicolas Pitre <nico@fluxnic.net>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-arch@vger.kernel.org, live-patching@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH v10 02/15] livepatch: avoid position-based search if `-z
 unique-symbol` is available
Message-ID: <20220211174130.xxgjoqr2vidotvyw@treble>
References: <20220209185752.1226407-1-alexandr.lobakin@intel.com>
 <20220209185752.1226407-3-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220209185752.1226407-3-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Feb 09, 2022 at 07:57:39PM +0100, Alexander Lobakin wrote:
> Position-based search, which means that if there are several symbols
> with the same name, the user needs to additionally provide the
> "index" of a desired symbol, is fragile. For example, it breaks
> when two symbols with the same name are located in different
> sections.
> 
> Since a while, LD has a flag `-z unique-symbol` which appends
> numeric suffixes to the functions with the same name (in symtab
> and strtab). It can be used to effectively prevent from having
> any ambiguity when referring to a symbol by its name.

In the patch description can you also give the version of binutils (and
possibly other linkers) which have the flag?

> Check for its availability and always prefer when the livepatching
> is on. It can be used unconditionally later on after broader testing
> on a wide variety of machines, but for now let's stick to the actual
> CONFIG_LIVEPATCH=y case, which is true for most of distro configs
> anyways.

Has anybody objected to just enabling it for *all* configs, not just for
livepatch?

I'd much prefer that: the less "special" livepatch is (and the distros
which enable it), the better.  And I think having unique symbols would
benefit some other components.

> +++ b/kernel/livepatch/core.c
> @@ -143,11 +143,13 @@ static int klp_find_callback(void *data, const char *name,
>  	args->count++;
>  
>  	/*
> -	 * Finish the search when the symbol is found for the desired position
> -	 * or the position is not defined for a non-unique symbol.
> +	 * Finish the search when unique symbol names are enabled
> +	 * or the symbol is found for the desired position or the
> +	 * position is not defined for a non-unique symbol.
>  	 */
> -	if ((args->pos && (args->count == args->pos)) ||
> -	    (!args->pos && (args->count > 1)))
> +	if (IS_ENABLED(CONFIG_LD_HAS_Z_UNIQUE_SYMBOL) ||
> +	    (args->pos && args->count == args->pos) ||
> +	    (!args->pos && args->count > 1))
>  		return 1;

There's no real need to do this.  The code already works as-is, even if
there are no unique symbols.

Even if there are no duplicates, there's little harm in going through
all the symbols anyway, to check for errors just in case something
unexpected happened with the linking (unexpected duplicate) or the patch
creation (unexpected sympos).  It's not a hot path, so performance isn't
really a concern.

When the old linker versions eventually age out, we can then go strip
out all the sympos stuff.

> @@ -169,6 +171,13 @@ static int klp_find_object_symbol(const char *objname, const char *name,
>  	else
>  		kallsyms_on_each_symbol(klp_find_callback, &args);
>  
> +	/*
> +	 * If the LD's `-z unique-symbol` flag is available and enabled,
> +	 * sympos checks are not relevant.
> +	 */
> +	if (IS_ENABLED(CONFIG_LD_HAS_Z_UNIQUE_SYMBOL))
> +		sympos = 0;
> +

Similarly, I don't see a need for this.  If the patch is legit then
sympos should already be zero.  If not, an error gets reported and the
patch fails to load.

-- 
Josh

