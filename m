Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2333E23AFBA
	for <lists+live-patching@lfdr.de>; Mon,  3 Aug 2020 23:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgHCVlK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Aug 2020 17:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgHCVlK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Aug 2020 17:41:10 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086BEC06174A
        for <live-patching@vger.kernel.org>; Mon,  3 Aug 2020 14:41:10 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d1so21676898plr.8
        for <live-patching@vger.kernel.org>; Mon, 03 Aug 2020 14:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AoXxxzPdcjWwfJPdErgifOsTsvhhfF5cKu6R8ZrrXiE=;
        b=cP3b+JMQBwVvMgicWaLrhYHCtWd5xoSj8dj2pYNIWtzEsYYJHvm6UFtv4fCjHWdqV/
         80FE7JTPA3xE9NC1kzqojZBRfaL8sYYxgslYAa7F69WcFl+x2nosPcFZb2Ok+yHsL99p
         qpAG8+RGZRwE8k74YOkvNHoo5nYxA1SiGOgV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AoXxxzPdcjWwfJPdErgifOsTsvhhfF5cKu6R8ZrrXiE=;
        b=bAK1KNClO9DHomTd4wZk4AuMk0L4Hw/URmjcBXhPBkndwY1fkupeCVwR1TtIxWrBTT
         7MFHxtQtVsJqNpUSFK4vOSdMkwReRq8AouFZUlcNlzK3A+Yocjj3jCasp0kbkGDL9+ud
         8cyhDXUw913QX2A5jLNBQwvArDTNOqSxZC4NWit4k1e9570Ax8LJZ9Fs3Qv1uYtXoDTv
         rbMIEQKWmQvF/XMktp+MnnFNYEp9GaIdkVuyY3taQxMNY4sh9qYKIBYplz75Q077ZbUb
         IZ2uhn6a0CuzDZpuVbhWbBRl+6jSMuf11wAfkm4quoAD7EGG123q6kylD6fVjNyMwm0k
         QdIA==
X-Gm-Message-State: AOAM5318tHzOWOqVmZfc3UqLK0H3yb2XF9YB7RM9rN6m+SNp8bCG2pir
        hOG+E0MslBPVR0J1TW6XHPScyw==
X-Google-Smtp-Source: ABdhPJzKfOSTGggKfBY9ChUZm4EGBh+2aAyWRhVuvypuYHUArV91N1Rdgtgk5e2SPvx0o4R9ZogITA==
X-Received: by 2002:a17:90a:6d96:: with SMTP id a22mr1158690pjk.26.1596490869599;
        Mon, 03 Aug 2020 14:41:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y65sm20383337pfb.155.2020.08.03.14.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:41:08 -0700 (PDT)
Date:   Mon, 3 Aug 2020 14:41:07 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Frank Ch. Eigler" <fche@redhat.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
        live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <202008031439.F1399A588@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
 <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
 <20200803193837.GB30810@redhat.com>
 <202008031310.4F8DAA20@keescook>
 <20200803211228.GC30810@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803211228.GC30810@redhat.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 03, 2020 at 05:12:28PM -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Mon, Aug 03, 2020 at 01:11:27PM -0700, Kees Cook wrote:
> > [...]
> > > Systemtap needs to know base addresses of loaded text & data sections,
> > > in order to perform relocation of probe point PCs and context data
> > > addresses.  It uses /sys/module/...., kind of under protest, because
> > > there seems to exist no MODULE_EXPORT'd API to get at that information
> > > some other way.
> > 
> > Wouldn't /proc/kallsysms entries cover this? I must be missing
> > something...
> 
> We have relocated based on sections, not some subset of function
> symbols accessible that way, partly because DWARF line- and DIE- based
> probes can map to addresses some way away from function symbols, into
> function interiors, or cloned/moved bits of optimized code.  It would
> take some work to prove that function-symbol based heuristic
> arithmetic would have just as much reach.

Interesting. Do you have an example handy? It seems like something like
that would reference the enclosing section, which means we can't just
leave them out of the sysfs list... (but if such things never happen in
the function-sections, then we *can* remove them...)

-- 
Kees Cook
