Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6904B5C71
	for <lists+live-patching@lfdr.de>; Mon, 14 Feb 2022 22:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiBNVP2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Feb 2022 16:15:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiBNVP2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Feb 2022 16:15:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADD34108180
        for <live-patching@vger.kernel.org>; Mon, 14 Feb 2022 13:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644873315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zw0m26jmgL5PSZbxc9F56RhQG8aGfeQzkdtSIlZWESE=;
        b=LMsNwamNoOVPANOQzh+vOa05pQm89LF61uXy8l9hWF9K8WA90f0VlR0DSpo8KU0pvPJhI4
        H2+VhowUxHV4SH/XXPg/VGadzICB0Ljp4ZSeV0nldFgUIQ9dk2eDtv0a1R0Y/i0exgskCB
        nQFu3L4k1fudQzFKooO4O7JJsRWjUtU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-nHZ-6rB4NACMY08SC1nmNA-1; Mon, 14 Feb 2022 13:57:55 -0500
X-MC-Unique: nHZ-6rB4NACMY08SC1nmNA-1
Received: by mail-qv1-f72.google.com with SMTP id o6-20020a0562140e4600b0042cf952661bso4118969qvc.10
        for <live-patching@vger.kernel.org>; Mon, 14 Feb 2022 10:57:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zw0m26jmgL5PSZbxc9F56RhQG8aGfeQzkdtSIlZWESE=;
        b=jhyA+tXkHVogFZVjWgYj3nyWe6BpkAR1hkHQaODIYlyk9poV637dYNXyZX8y0doY2n
         Z3CQLepwSSv43disxLGdSNjIqV3AdU8QW6thOH3tgRq4oxP0U755daChcrLzjSdrpYQS
         KtB4i0tbKbmva2gPsxseBy29MOpJjasTO3YfzKo/TJ4g5ITfdHn1Zg0qDRT9enxKit/1
         SNFr5+YPKQkjR86RJhKleLy2PsW63Zvw5Zjro1M2Hb/M7iC0OvhUC8FX7xbHeieUJNgm
         EtNSDb3VuIdJnfMNj6DXdsRkH67DjFCwoFgd9I2UMcY6/NaBxhQf/J/0BR9P987iZQIs
         WzQw==
X-Gm-Message-State: AOAM531IN5bzJNLzOa6yscEEKPimgWzGUbPnYng4coxCKxtuz8w8HDC5
        ceJvZkAPgpjtOYI0FgYpOFD325jJAnaxBi3vcf+Ai1ywiqyKFKrW9dI4hl2lN2PO4G+Z4YtrvWM
        BjRzBBG0Wf0EOY9Y0YlrPdgH2iw==
X-Received: by 2002:ad4:58f1:: with SMTP id di17mr81615qvb.36.1644865075190;
        Mon, 14 Feb 2022 10:57:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysuyQMRiLKO/pEhsQy4DxLU5S9UbooAkR2s9LJCJ+c5txevugMskSZ+48nNPU8AiQWi+8+Lg==
X-Received: by 2002:ad4:58f1:: with SMTP id di17mr81584qvb.36.1644865074915;
        Mon, 14 Feb 2022 10:57:54 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::35])
        by smtp.gmail.com with ESMTPSA id i13sm16244149qko.91.2022.02.14.10.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 10:57:54 -0800 (PST)
Date:   Mon, 14 Feb 2022 10:57:48 -0800
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
Message-ID: <20220214185748.ite4oxkaynrvjj34@treble>
References: <20220209185752.1226407-1-alexandr.lobakin@intel.com>
 <20220209185752.1226407-3-alexandr.lobakin@intel.com>
 <20220211174130.xxgjoqr2vidotvyw@treble>
 <20220214121447.288695-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220214121447.288695-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

NOTE: Maybe -zunique-symbol won't get used after all, based on maskray's
objections.  Regardless, I'm replying below, because the rest of the
approach in this patch seems all wrong.

On Mon, Feb 14, 2022 at 01:14:47PM +0100, Alexander Lobakin wrote:
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> Date: Fri, 11 Feb 2022 09:41:30 -0800
> 
> > On Wed, Feb 09, 2022 at 07:57:39PM +0100, Alexander Lobakin wrote:
> > > Position-based search, which means that if there are several symbols
> > > with the same name, the user needs to additionally provide the
> > > "index" of a desired symbol, is fragile. For example, it breaks
> > > when two symbols with the same name are located in different
> > > sections.
> > > 
> > > Since a while, LD has a flag `-z unique-symbol` which appends
> > > numeric suffixes to the functions with the same name (in symtab
> > > and strtab). It can be used to effectively prevent from having
> > > any ambiguity when referring to a symbol by its name.
> > 
> > In the patch description can you also give the version of binutils (and
> > possibly other linkers) which have the flag?
> 
> Yeah, sure.

> > > Check for its availability and always prefer when the livepatching
> > > is on. It can be used unconditionally later on after broader testing
> > > on a wide variety of machines, but for now let's stick to the actual
> > > CONFIG_LIVEPATCH=y case, which is true for most of distro configs
> > > anyways.
> > 
> > Has anybody objected to just enabling it for *all* configs, not just for
> > livepatch?
> 
> A few folks previously.

Why?  It would be good to document that here.

> > I'd much prefer that: the less "special" livepatch is (and the distros
> > which enable it), the better.  And I think having unique symbols would
> > benefit some other components.
> 
> Agree, I just want this series to be as least invasive for
> non-FG-KASLR builds as possible.

But in a very real sense, this patch is making the series *more*
invasive by complexifying the config space.

Adding -zunique-symbols could have kernel-wide implications.  If there
were bugs, we'd want to root them out, not hide them behind obscure
config combinations we hope nobody uses.  Effectively this is
destabilizing CONFIG_LIVEPATCH.

Beyond "least invasive", we also need to consider:

- What makes fgkaslr most compatible with other features?
- What makes fgkaslr most palatable for wide use?
- What's best for the kernel as a whole?

It's much better to integrate new features properly with the kernel,
rather than just grafting them on to the side.  Otherwise it just adds
technical debt, with no benefit to the rest of the kernel.  Then it
might as well just remain an out-of-tree patch set.

> > > +	if (IS_ENABLED(CONFIG_LD_HAS_Z_UNIQUE_SYMBOL))
> > > +		sympos = 0;
> > > +
> > 
> > Similarly, I don't see a need for this.  If the patch is legit then
> > sympos should already be zero.  If not, an error gets reported and the
> > patch fails to load.
> 
> Right, but for both those chunks the main idea is to let the
> compiler optimize-out the code non-actual for unique-symbol builds:
> 
> add/remove: 0/0 grow/shrink: 1/2 up/down: 3/-80 (-77)
> Function                                     old     new   delta
> klp_find_callback                            139     142      +3
> klp_find_object_symbol.cold                   85      48     -37
> klp_find_object_symbol                       168     125     -43

As I said, it's not a hot path, so there's no need to complicate the
code with edge cases, and remove useful error checking in the process.

-- 
Josh

