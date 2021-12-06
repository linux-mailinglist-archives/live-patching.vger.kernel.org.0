Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78E4469059
	for <lists+live-patching@lfdr.de>; Mon,  6 Dec 2021 07:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhLFGQc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Dec 2021 01:16:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56855 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237684AbhLFGQb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Dec 2021 01:16:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638771183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4xWGrLSvjQyZR18KAyL7VVlj7HygqxFS8q4PmqDkH30=;
        b=iTUTYVcK4kaLqNvq1L6a80CygVRquoayMCK1s7OVfaPmHLpk5PCEKVeqJZ+F1e9gmyapSX
        er0vDvtgqMuBlZuW8GoiMytg4LAwJ46maTTLA2AWy4AINQAozaBGnrC6d94FlpGAWCOPwL
        mQLUEYGkj067FwdNXIDU1EYWgl+st+I=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-byviVvHcOa-q3LOBjbx-_Q-1; Mon, 06 Dec 2021 01:13:02 -0500
X-MC-Unique: byviVvHcOa-q3LOBjbx-_Q-1
Received: by mail-qv1-f70.google.com with SMTP id ib7-20020a0562141c8700b0040812bc4425so7739807qvb.16
        for <live-patching@vger.kernel.org>; Sun, 05 Dec 2021 22:13:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4xWGrLSvjQyZR18KAyL7VVlj7HygqxFS8q4PmqDkH30=;
        b=0XZB1EM52Jm9mBzd/Zm8BpSEssq+Ci7NM2LIzAMXuR/C7jAH30Zm5CQAqcqMwzRVJJ
         uxLvZZySZvBlE/2Vn9SFkrQ/83MKVNl7bMy/DAx9G/u6TO2PNqL9CTP65LV0K/mNUcpw
         0jz4j56++R/2xR7ZrZEbnjRXANpZuHAZMQf550638a+zGC/eHX05KdXg5sXnGMLR5Ru7
         OJw7kL4pcYNeZ8HvfykuAPdOpU9Fy4X+dn5I/ENs8JfLFNkvkleSuuPpIXkg16ozstYZ
         Z8NjpqPwkv+e7rSZYXWq+v1Xhn5xPXLjtffaB8+X7azOpuIXg9xBH4dN/+XMJ8frl5tE
         BLZg==
X-Gm-Message-State: AOAM531dv1moLXxa9sO10bNW4gpMyiEmYMRZuJYCi8crVOeBqrnqFSc3
        oFEOI7htuXC3QHoyQCLirIv6TrjCBOZ39bKfYmzjYS0o66MVPiRXx3VuyZ8doB/3mV05Oy9XRjW
        RGsWGNQSskbQYLYbnzsaiT4eYoQ==
X-Received: by 2002:a05:620a:d95:: with SMTP id q21mr8073428qkl.74.1638771181660;
        Sun, 05 Dec 2021 22:13:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjC5ebHKpwY9hHoFIDys4KZw9oXh61/oY+P+rjvvtF+AaorurZKGCFs+XRxeKDSlFmeaRn/w==
X-Received: by 2002:a05:620a:d95:: with SMTP id q21mr8073420qkl.74.1638771181413;
        Sun, 05 Dec 2021 22:13:01 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::45])
        by smtp.gmail.com with ESMTPSA id 16sm6977663qty.2.2021.12.05.22.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 22:13:00 -0800 (PST)
Date:   Sun, 5 Dec 2021 22:12:58 -0800
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>, joao@overdrivepizza.com,
        nstange@suse.de, pmladek@suse.cz, live-patching@vger.kernel.org
Subject: Re: CET/IBT support and live-patches
Message-ID: <20211206061258.df64727kssiil5ed@treble>
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com>
 <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz>
 <08d4a24d-02c2-6760-96bf-b72f51025808@redhat.com>
 <20211123211636.GE721624@worktop.programming.kicks-ass.net>
 <ec0205e5-c974-35d4-651a-f622f44fb84e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ec0205e5-c974-35d4-651a-f622f44fb84e@redhat.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Dec 01, 2021 at 01:57:00PM -0500, Joe Lawrence wrote:
> On 11/23/21 4:16 PM, Peter Zijlstra wrote:
> > On Tue, Nov 23, 2021 at 03:58:51PM -0500, Joe Lawrence wrote:
> > 
> >> Yep, kpatch-build uses its own klp-relocation conversion and not kallsyms.
> >>
> >> I'm not familiar with CET/IBT, but it sounds like if a function pointer
> >> is not taken at build time (or maybe some other annotation), the
> >> compiler won't generate the needed endbr landing spot in said function?
> > 
> > Currently it does, but then I'm having objtool scribble it on purpose.
> > 
> 
> Hi Peter -- to follow up on the objtool part: what criteria is used to
> determine that it may scribble out the endbr?

ENDBR is "scribbled" for any function for which no function pointer data
relocation exists at vmlinux or module link time.

https://lkml.kernel.org/r/20211122170301.764232470@infradead.org

-- 
Josh

