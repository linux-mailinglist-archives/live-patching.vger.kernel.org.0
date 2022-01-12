Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571A348CB23
	for <lists+live-patching@lfdr.de>; Wed, 12 Jan 2022 19:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356344AbiALSkE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 12 Jan 2022 13:40:04 -0500
Received: from mail-qt1-f175.google.com ([209.85.160.175]:45894 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343802AbiALSkE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 12 Jan 2022 13:40:04 -0500
Received: by mail-qt1-f175.google.com with SMTP id b14so1152655qtb.12;
        Wed, 12 Jan 2022 10:40:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SHMsecJ8ito+ZjaM2mgBEtgzX8Hsm1yYGc520Y3Oqz8=;
        b=lKMPDLXN3zXkUAWEtwT3JkrLiDBkuCUw5HNcjFtD+KRHewdrIPV5HAj8Pbwods+WDA
         QZ6/MeuXnQaZ1itmGtxH8P/vZYM25GZt2clYn+/gijjdslY/fQshq5YYLZ2Sy3ItLIxr
         KO6vDiic7mDGM78mDW3PP9oQHdn1nvyu//9z/ufuJiMvoI82BU3kNXNICnqMInUclGBC
         RKtBs7wL2hgRHTjjtZAfDJ+Cv/9MK9fs0K6+uEtAbiTnigIZkMYqwjtrnfRQXStOuIzU
         YbiRgF2Ok6ePLsEWvVGX2SgcZ+iPAsTgidyN00G6feNC45NAT170C9weskwBChRur71e
         LvTw==
X-Gm-Message-State: AOAM530VN3b6GsyFPcqkiFSvqb3C3EXEOJiCwJfSQWAv7cmlBlZJ+sVg
        IXePCpxipOx5BmWKM5VqrYk=
X-Google-Smtp-Source: ABdhPJw03VKdK1+PcPQ/JWmwMiqLmPGVfz70lYqyiH2/RxLh+Suh14yEgr0jVjwNAEOnI543U2sU8A==
X-Received: by 2002:a05:622a:1493:: with SMTP id t19mr768971qtx.230.1642012803451;
        Wed, 12 Jan 2022 10:40:03 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-007.fbsv.net. [2a03:2880:20ff:7::face:b00c])
        by smtp.gmail.com with ESMTPSA id n11sm398275qtk.44.2022.01.12.10.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 10:40:03 -0800 (PST)
Date:   Wed, 12 Jan 2022 10:40:01 -0800
From:   David Vernet <void@manifault.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Aaron Tomlin <atomlin@redhat.com>, mcgrof@kernel.org, cl@linux.com,
        mbenes@suse.cz, akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        atomlin@atomlin.com, ghalat@redhat.com, allen.lkml@gmail.com,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH v2 03/13] module: Move livepatch support to a
 separate file
Message-ID: <Yd8ggcNEWgqAwmcD@dev0025.ash9.facebook.com>
References: <20220106234319.2067842-1-atomlin@redhat.com>
 <20220106234319.2067842-4-atomlin@redhat.com>
 <Yd8HpK44aWhhNI/Q@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd8HpK44aWhhNI/Q@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Petr Mladek <pmladek@suse.com> wrote on Wed [2022-Jan-12 17:53:56 +0100]:
> It would be better to have the two variants close each other. I mean
> to have it somewhere like:
> 
> #ifdef CONFIG_LIVEPATCH
> 
>    variant A
> 
> #else
> 
>    variant B
> 
> #endif
> 

<snip>

> #ifdef CONFIG_LIVEPATCH
> static inline bool set_livepatch_module(struct module *mod)
> {
> 	mod->klp = true;
> 	return true;
> }
> #else /* !CONFIG_LIVEPATCH */
> static inline bool set_livepatch_module(struct module *mod)
> {
> 	return false;
> }
> #endif /* CONFIG_LIVEPATCH */
> 
> 
> Well, it might be matter of taste. Others might prefer another solution.
> Adding live-patching mailing list into Cc.

+1 -- this seems like a cleaner approach.

- David
