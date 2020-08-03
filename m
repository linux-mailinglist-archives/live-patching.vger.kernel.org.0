Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF5F23ADF9
	for <lists+live-patching@lfdr.de>; Mon,  3 Aug 2020 22:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgHCULa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Aug 2020 16:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgHCUL3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Aug 2020 16:11:29 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4F0C06174A
        for <live-patching@vger.kernel.org>; Mon,  3 Aug 2020 13:11:29 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k13so13675381plk.13
        for <live-patching@vger.kernel.org>; Mon, 03 Aug 2020 13:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TfiyLaiiytHrMlT6oh4IsfhQ9YFyy5wx3zu6IU7BZNY=;
        b=HeAvcOEzYgF+GPngOCTfUbepzuEHkx+8qRmbejrCRY0MMmgn7UeyBWYdJzytoGD/Ta
         qJv07CPlJcF29ETgPuWONUktPZBp3nwXCAW6eRZRISbnRUQRb/KL+l6+49U1G00uxaJ2
         G8Xq9iIuiiHpWvLKYqRaN87kEr5QcIdg7wdbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TfiyLaiiytHrMlT6oh4IsfhQ9YFyy5wx3zu6IU7BZNY=;
        b=RvZbbRE1PD54ZcosSZDoJzIJ5g2RnACoZaWO4MLKzjMBaZnFOQh+tw2ntxgHYlTaLH
         JzmR25djVIDf6bmuoorAnEpHaq+hq/X66NBqcUfAFqaxcgJCEwIlKUh7NVeP4r4SJzEg
         nZmLDyvca5jwHtizTJ4EB6di/8wHygoTiT7dc7Zdvz35tncRYykyduh3jDhy1fp7sxzz
         7DFqrV0iwYwDrZo/bfFf3K/YLniK+BulW7vmh52HQ3zf0xhKV/9Ib9D1GXIYdYiF3Owb
         QwesQo6+4GAysfril5yVTPsDJSXcr0vLFjaQfLaKF4BHEszaeeRX5Ypq4LPETijvLhXX
         JCng==
X-Gm-Message-State: AOAM533PbGwuOHinNcxNArJq0raeDvR1BREfr+H9iG3B949se4uGtDuk
        EMn/wB2YODAkNjcH84OdhukTew==
X-Google-Smtp-Source: ABdhPJx5soepBCB5jCgc7HTF/4STC+NuKiuSvs2LauZE/NK7WGz7+MhS+gn47Q/oX5PA+CVBiIyxZw==
X-Received: by 2002:a17:90a:7f02:: with SMTP id k2mr942128pjl.196.1596485489540;
        Mon, 03 Aug 2020 13:11:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d2sm18527244pgp.17.2020.08.03.13.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 13:11:28 -0700 (PDT)
Date:   Mon, 3 Aug 2020 13:11:27 -0700
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
Message-ID: <202008031310.4F8DAA20@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
 <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
 <20200803193837.GB30810@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803193837.GB30810@redhat.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 03, 2020 at 03:38:37PM -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> > > While this does seem to be the right solution for the extant problem, I
> > > do want to take a moment and ask if the function sections need to be
> > > exposed at all? What tools use this information, and do they just want
> > > to see the bounds of the code region? (i.e. the start/end of all the
> > > .text* sections) Perhaps .text.* could be excluded from the sysfs
> > > section list?
> 
> > [[cc += FChE, see [0] for Evgenii's full mail ]]
> 
> Thanks!
> 
> > It looks like debugging tools like systemtap [1], gdb [2] and its
> > add-symbol-file cmd, etc. peek at the /sys/module/<MOD>/section/ info.
> > But yeah, it would be preferable if we didn't export a long sysfs
> > representation if nobody actually needs it.
> 
> Systemtap needs to know base addresses of loaded text & data sections,
> in order to perform relocation of probe point PCs and context data
> addresses.  It uses /sys/module/...., kind of under protest, because
> there seems to exist no MODULE_EXPORT'd API to get at that information
> some other way.

Wouldn't /proc/kallsysms entries cover this? I must be missing
something...

-- 
Kees Cook
