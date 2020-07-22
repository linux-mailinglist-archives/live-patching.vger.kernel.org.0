Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FA022A03A
	for <lists+live-patching@lfdr.de>; Wed, 22 Jul 2020 21:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgGVTmx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jul 2020 15:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgGVTmx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jul 2020 15:42:53 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AC8C0619DC
        for <live-patching@vger.kernel.org>; Wed, 22 Jul 2020 12:42:52 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m16so1499869pls.5
        for <live-patching@vger.kernel.org>; Wed, 22 Jul 2020 12:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j8EVfDnsbKkDzkQmKYCo8r+kuzC3a5xUIaeiauPjHyg=;
        b=UQTdPm/nC+HkSL2BrWnoVYlDw4QRQrGAqDirB5zm5BpUzgtCvJy4d6xrBDUdh5Guck
         /So1K/Y/MIZEeY8A8JAEnjxncJ8eGOce7xc0/mjnlbSh3Wd2At8ckPa28ZKIzSZ4bf/0
         ZywAUOxsQOzs1FswGb+32DSfL9xYxikcwziYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j8EVfDnsbKkDzkQmKYCo8r+kuzC3a5xUIaeiauPjHyg=;
        b=ApGBy38lg5GYQaO9Yd8OkSp8YZ3fXDDTycgS1MBP0NkfsjeeOVMlapWvmBn66Va4vK
         MtZVfFxpld5APTgctvOjHTiXmVbyqppgDTnvKbwao/rU/N+NEDCE8AJajZ2WUuS7t4Vm
         9WLd1/HC8wGSXpvHhEQoG9T5ibFWxF9J7+roj1RnnormXRSRVPVfg9qLd4SmaGSSJKa5
         EG0RgCaxxL3r6udNKKVPMk6HiIPQE+e+jQDyn7+X0CdN9c8Idx6L0b/JE7G9KVrCQnXZ
         +f2K2CBJY1pgDaUdcOKy5nDz2ae2bHr289MwGJ3VjZa2z/y3NJLFN8DHO9Hd/n0VUA+D
         +cdQ==
X-Gm-Message-State: AOAM532DNb+LaMEgteB/rpKPdWOwWdPCaANZ0IPGguhFt5dw9T17VxZ2
        J+Wuw1a2BotRRz6lf6Kmt6h4LQ==
X-Google-Smtp-Source: ABdhPJwNDMuWHpZri+I/lnXdThH9TpOPI3+GSq/C/NGpYVJ4A3ptfCQ9jBQki7H6FXs3LEtMLCmGWw==
X-Received: by 2002:a17:90b:2350:: with SMTP id ms16mr903643pjb.127.1595446972510;
        Wed, 22 Jul 2020 12:42:52 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k98sm476660pjb.42.2020.07.22.12.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 12:42:51 -0700 (PDT)
Date:   Wed, 22 Jul 2020 12:42:50 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        arjan@linux.intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        rick.p.edgecombe@intel.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <202007221241.EBC2215A@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook>
 <20200722160730.cfhcj4eisglnzolr@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722160730.cfhcj4eisglnzolr@treble>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 22, 2020 at 11:07:30AM -0500, Josh Poimboeuf wrote:
> On Wed, Jul 22, 2020 at 07:39:55AM -0700, Kees Cook wrote:
> > On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
> > > Let me CC live-patching ML, because from a quick glance this is something 
> > > which could impact live patching code. At least it invalidates assumptions 
> > > which "sympos" is based on.
> > 
> > In a quick skim, it looks like the symbol resolution is using
> > kallsyms_on_each_symbol(), so I think this is safe? What's a good
> > selftest for live-patching?
> 
> The problem is duplicate symbols.  If there are two static functions
> named 'foo' then livepatch needs a way to distinguish them.
> 
> Our current approach to that problem is "sympos".  We rely on the fact
> that the second foo() always comes after the first one in the symbol
> list and kallsyms.  So they're referred to as foo,1 and foo,2.

Ah. Fun. In that case, perhaps the LTO series has some solutions. I
think builds with LTO end up renaming duplicate symbols like that, so
it'll be back to being unique.

-- 
Kees Cook
