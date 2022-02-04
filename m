Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7302C4AA14E
	for <lists+live-patching@lfdr.de>; Fri,  4 Feb 2022 21:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbiBDUnI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Feb 2022 15:43:08 -0500
Received: from mail-qv1-f47.google.com ([209.85.219.47]:44648 "EHLO
        mail-qv1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiBDUnH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Feb 2022 15:43:07 -0500
Received: by mail-qv1-f47.google.com with SMTP id s6so6280825qvv.11;
        Fri, 04 Feb 2022 12:43:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SeQpErg+pqUWoMMUN/s+CKvp6anFV4NT1Sj3N+mIao4=;
        b=lipk98sVcf1EZ3vYxkNquQmnSh4EGMHoT92xNvFszIoWkqeSA8YUvjTSE2JVEgS44k
         LidAKCV0sEkIa5EVjd0OjcnxWtWW0iEVHv4NARkpzNUv1hQXv0hTSvEapqb+tF5kmryz
         yz8S/tFKDCiZ3hwt9bvOPdCVW2BXWvfjOJZeY3/qeJXzHI+/rBaQB9UeV0gKN8lwONBf
         meFNk36O/bbHN4Ahs2RIrjUc9spLs/zr1ou1tqvI0Qf8A/Qd27ADPABHTGF0m6m/0Yrw
         eiQG8lwHZyqn2pwPemU5+7aCxxXCkg0E04bdTBwN8/xryK824kPXj9qApNngVY5Z6TQT
         VC8g==
X-Gm-Message-State: AOAM5315OnHpTvi3otYsmI8zs1NcKYAuaDliAiX0sIagmAqxTnGpD880
        y4/aAoJyRAFLDunYJBxuvTE=
X-Google-Smtp-Source: ABdhPJy0LzBPjh0oz3V5pGngWStApYMS101cS3sGnf129ma+5pgHBd0EGrv4mnpCCGLQTlMLM3SgnQ==
X-Received: by 2002:a05:6214:252c:: with SMTP id gg12mr3373508qvb.3.1644007387071;
        Fri, 04 Feb 2022 12:43:07 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-012.fbsv.net. [2a03:2880:20ff:c::face:b00c])
        by smtp.gmail.com with ESMTPSA id v73sm1473855qkb.51.2022.02.04.12.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 12:43:06 -0800 (PST)
Date:   Fri, 4 Feb 2022 12:43:03 -0800
From:   David Vernet <void@manifault.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, jikos@kernel.org,
        mbenes@suse.cz, corbet@lwn.net, kernel-team@fb.com
Subject: Re: [PATCH] livepatch: Skip livepatch tests if ftrace cannot be
 configured
Message-ID: <20220204204303.scyxvt4yh2gjftce@dev0025.ash9.facebook.com>
References: <20220203233205.1554034-1-void@manifault.com>
 <917650f7-4e8c-4643-77d3-45d1ebbb217f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <917650f7-4e8c-4643-77d3-45d1ebbb217f@redhat.com>
User-Agent: NeoMutt/20211029
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Feb 04, 2022 at 03:30:02PM -0500, Joe Lawrence wrote:

Hi Joe,

Thanks for the review.

> sp: s/permament/permanent
> 

Ack, thanks for catching that.

> > +	if [[ "$result" == *"Device or resource busy"* ]]; then
> > +		skip "failed to set kernel.ftrace_enabled=$1"
> > +	fi
> > +
> 
> style nit: move the blank line from here to just before the new # Skip
> comment

Ack.

> Can we be more paranoid and just look for the exact result that we expect:
> 
> if [[ "$result" != "kernel.ftrace_enabled = 1" ]]; then
> 	skip "failed to set kernel.ftrace_enabled=$1"
> fi

Agreed, this is cleaner and less brittle.

I'll follow-up with a v2 patch shortly. Thanks!

- David
