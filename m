Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D9F46904E
	for <lists+live-patching@lfdr.de>; Mon,  6 Dec 2021 07:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbhLFGH3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Dec 2021 01:07:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235803AbhLFGH2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Dec 2021 01:07:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638770640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wo70tjI7q1UAqboatbwLl0h/uu/FTe3Affu+qnLiGkQ=;
        b=I+YD0h8PopC/clkNTf8IQ4Lek1PWY38J6Nm7Y3G3nMz/n9VgFlE2DxpuUg18FgKKBsPwuu
        wAJtE/f38QLRLl3BE8PWRinJzMSvjtjBlA50K7XOEGsFgT/PYSiXx6azxm/zRWqUuYHUrT
        2kQqgPE/ZTWM0O0+K/Yfn/353BTf9Sg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-3u7d-OVZOo6pmyeuBc23Fg-1; Mon, 06 Dec 2021 01:03:58 -0500
X-MC-Unique: 3u7d-OVZOo6pmyeuBc23Fg-1
Received: by mail-qv1-f72.google.com with SMTP id kk1-20020a056214508100b003a9d1b987caso10745644qvb.4
        for <live-patching@vger.kernel.org>; Sun, 05 Dec 2021 22:03:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wo70tjI7q1UAqboatbwLl0h/uu/FTe3Affu+qnLiGkQ=;
        b=3iJcttGPXAysSWPwtks71U4s97INZ8751HCX1y0h1Ud4+cT05hSC+c98tjGWzrdwnB
         prML22WA+J4tdpuaav4QSjnYu2wsROGoU2QQ8OEVsmum12c6iPEmFRFKF1ZiGmpvEoy9
         I/db+/Ku06ZKMIwGQ142fFGAj4GV9fGk92Aa7O5BBndvLOqhGKLgogI5OB57So9y892c
         IUfkpJv+4yngg27KvB9ubps5pwSNqzg3MT0SPyfu7e3yZrVp+7NF8Z5fusCykIfmMwXT
         BNbiA1MZOxKuPONEt6/bCxjIXsXXtgF9VUkQh9Bsk2M4kQMsxuhr456Z83H7kdmb/TQT
         ryZQ==
X-Gm-Message-State: AOAM530a1oZyWO/UQPOTGWyEAbHMsqM2WNBeKT0PC7FRzFAHpYUIaEfC
        Ncg8Zp987kLWpQ512xbgr2M1FBqZh4Wd2IvmOqWSvdikTSL9zYWd6wsoo8Hp0au+hSiPyQfFk9B
        9NARZRVprHYBRwwLrVc4bhUvNuw==
X-Received: by 2002:ac8:5bcf:: with SMTP id b15mr37503559qtb.474.1638770637759;
        Sun, 05 Dec 2021 22:03:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBlcOgv7DcKhfVmXiMUiPn6jj3Lbd0IoNd3WtPjyxukoKwU1wdw7FB6qmJfkTYOfo/DTS8HA==
X-Received: by 2002:ac8:5bcf:: with SMTP id b15mr37503536qtb.474.1638770637542;
        Sun, 05 Dec 2021 22:03:57 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::45])
        by smtp.gmail.com with ESMTPSA id y20sm6176312qkj.24.2021.12.05.22.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 22:03:56 -0800 (PST)
Date:   Sun, 5 Dec 2021 22:03:50 -0800
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        linux-hardening@vger.kernel.org, x86@kernel.org,
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
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Marios Pomonis <pomonis@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-arch@vger.kernel.org, live-patching@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH v8 08/14] livepatch: only match unique symbols when using
 FG-KASLR
Message-ID: <20211206060350.f4hqug2jhgjlaw3c@treble>
References: <20211202223214.72888-1-alexandr.lobakin@intel.com>
 <20211202223214.72888-9-alexandr.lobakin@intel.com>
 <YansAlTr0/MfNxWc@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YansAlTr0/MfNxWc@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Dec 03, 2021 at 11:05:54AM +0100, Peter Zijlstra wrote:
> On Thu, Dec 02, 2021 at 11:32:08PM +0100, Alexander Lobakin wrote:
> > If any type of function granular randomization is enabled, the sympos
> > algorithm will fail, as it will be impossible to resolve symbols when
> > there are duplicates using the previous symbol position.
> > 
> > We could override sympos to 0, but make it more clear to the user
> > and bail out if the symbol is not unique.
> 
> Since we're going lots of horrendous things already, why can't we fix
> this duplicate nonsense too?

I assume you mean using this new linker flag: "-z unique-symbol"

https://sourceware.org/bugzilla/show_bug.cgi?id=26391

-- 
Josh

