Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEB923ABC9
	for <lists+live-patching@lfdr.de>; Mon,  3 Aug 2020 19:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgHCRpi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Aug 2020 13:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgHCRpi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Aug 2020 13:45:38 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD633C061756
        for <live-patching@vger.kernel.org>; Mon,  3 Aug 2020 10:45:37 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 2so329883pjx.5
        for <live-patching@vger.kernel.org>; Mon, 03 Aug 2020 10:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8VKCoo7Vmd7+mSWuTkGx9LAevVUhaDOReRxys5hawyY=;
        b=g6QLhlkTh78wPq19hgd3aCUUx0Imw7hHpDpHRoUNeo8fIu9NRFI4aUriW0Z9BZniQG
         YzPHxc2H1xDFqOxe+EWig27ebzxgINQXziK4Nb917fzY4xDxIZ66ACPlaTcIxxII7O3R
         WglKCd8y5damXG5BfnBTutACt6Bn2FSIsAjWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8VKCoo7Vmd7+mSWuTkGx9LAevVUhaDOReRxys5hawyY=;
        b=aRiaKAg3/BdbwZ4jeFfpWX/ygc04bafNK8e3sotz/fybCf+ZVGjW2Nrn0vdZPT1810
         Cylih9LS5OGwIoB12KfXfyeGMkYo67zs/E/GJ6nt4zne2pXl2NOgqG03R2IoYikG9Rbp
         Pqqqbq8VbiAGYAgboa5Vp4aslWX18i6+gGtqdRFWxNpxAiuTwM/fLsp0VpILZP/eC0Fy
         USys0me5qjllD4Q+NjLhJ6nNkTEL4k6pwZCnvTVMYrPCrRbm6rEQ0D4ACaK/U+/Nrj6B
         znLNztcstSGJeuDQedxFaQjr3CDyay2WLr5UUoTUO/gNAu8GuTUsNpaM5j/nSL6FXmMK
         GkIg==
X-Gm-Message-State: AOAM530F+ibchJIcJZd5EsbvkEOdkZ5wFnhk6+WdXbYiItjfQs8ZJ/Oc
        YaXdv6dQRgd64eAOlgpL+z+XJg==
X-Google-Smtp-Source: ABdhPJzGj8xXq4IjYCLnxux+Nc8xy7BtserkIGiDWL6WvrAEGhBWNwOQEcukf/40EE3PYPMrIuBRGw==
X-Received: by 2002:a17:90a:ca85:: with SMTP id y5mr430416pjt.87.1596476737437;
        Mon, 03 Aug 2020 10:45:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j4sm21161622pfd.92.2020.08.03.10.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 10:45:36 -0700 (PDT)
Date:   Mon, 3 Aug 2020 10:45:35 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Cc:     Kristen Carlson Accardi <kristen@linux.intel.com>,
        Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
        live-patching@vger.kernel.org,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <202008031043.FE182E9@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 03, 2020 at 02:39:32PM +0300, Evgenii Shatokhin wrote:
> There are at least 2 places where high-order memory allocations might happen
> during module loading. Such allocations may fail if memory is fragmented,
> while physically contiguous memory areas are not really needed there. I
> suggest to switch to kvmalloc/kvfree there.

While this does seem to be the right solution for the extant problem, I
do want to take a moment and ask if the function sections need to be
exposed at all? What tools use this information, and do they just want
to see the bounds of the code region? (i.e. the start/end of all the
.text* sections) Perhaps .text.* could be excluded from the sysfs
section list?

-- 
Kees Cook
