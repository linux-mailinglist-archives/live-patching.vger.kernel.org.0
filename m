Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B5F3B76A3
	for <lists+live-patching@lfdr.de>; Tue, 29 Jun 2021 18:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhF2QuN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 29 Jun 2021 12:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234160AbhF2QuM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 29 Jun 2021 12:50:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624985265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+bJvwmYTs4hsRIzvijlTBKZHCJnIV9JSQ/ae942P0nQ=;
        b=TRWT2D2MZA1qjDDTpPsXkqzp5kK0OwTPjfnvk6Yuh34Zf0y8MZyOeyW45XIP1yO7NsyLsR
        0KbiPAa/d84IZ360PJRH/M3RJiqLxFbH2l1zxm1vgAsbiD3aiSLADBkLSvmx+GP1LB9hOM
        SZ5JRyhU5AzNlw6vhcvt6zz06xEOjnk=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-ULSGEkxRP5WIBHxzVMYd_Q-1; Tue, 29 Jun 2021 12:47:43 -0400
X-MC-Unique: ULSGEkxRP5WIBHxzVMYd_Q-1
Received: by mail-pg1-f198.google.com with SMTP id 4-20020a6315440000b029022154a87a57so14567144pgv.13
        for <live-patching@vger.kernel.org>; Tue, 29 Jun 2021 09:47:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+bJvwmYTs4hsRIzvijlTBKZHCJnIV9JSQ/ae942P0nQ=;
        b=NI49t/M8HSmyJLc9onDFYyVMYcO9w+pXI9S654BJk17RCv6GfsaydINhxdoGRmRO6C
         BS5sUG9rwGK0ssR9KSwcIxgw0+zsweS/VWF+xvjuFaqhysr2J0iyCpveD3XE8WREmj90
         bf2JlYr4pC+Ki2UxWANgM3ZlgSSnB2pk7C+nMfcTxnnBIyIQlCuWFcuRa6G8Gm1rd2gl
         CuBKkBfGJB+OTAGqRwlKaMgA6EjSzl0Qrw61w/TDplPVUMshJ1TeD88Pd/hoc1/8zG9E
         WCXIrPYXFiR6yKLjBZ0S6yxrcN46ZLW0Zb80Hdc6UihDaSWxlN7f16mBHXIc5yyOw5FH
         J2yg==
X-Gm-Message-State: AOAM533h6WGaUkaYezLYz0qNpVdVFxkWk04WpmqG4ddHk8IxmWbZV4CE
        TlODoDXpANHxjaxvnfUlxCZaoXFYdpBtCsy+fj/TfkMui3VJaIG0j24ljfTNsGNahqIEsZljKO+
        DfDMrxrL3y1RarWdE200TXHKBbA==
X-Received: by 2002:a17:90a:650b:: with SMTP id i11mr34962309pjj.39.1624985262581;
        Tue, 29 Jun 2021 09:47:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3vTTwAHy6BETIsORLHGghBWZRgo8av0Cd/hHZW70tMvDWoqyHwTA6FD/HIjdC3imDZWBejQ==
X-Received: by 2002:a17:90a:650b:: with SMTP id i11mr34962286pjj.39.1624985262349;
        Tue, 29 Jun 2021 09:47:42 -0700 (PDT)
Received: from treble ([2600:380:8772:6cac:dfb6:1d6c:e068:2f39])
        by smtp.gmail.com with ESMTPSA id u2sm6013505pja.20.2021.06.29.09.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 09:47:41 -0700 (PDT)
Date:   Tue, 29 Jun 2021 11:47:36 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     madvenka@linux.microsoft.com, broonie@kernel.org, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v5 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210629164736.dnysynhkjjxya4vc@treble>
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
 <20210526214917.20099-1-madvenka@linux.microsoft.com>
 <20210526214917.20099-2-madvenka@linux.microsoft.com>
 <20210624144021.GA17937@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210624144021.GA17937@C02TD0UTHF1T.local>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jun 24, 2021 at 03:40:21PM +0100, Mark Rutland wrote:
> Hi Madhavan,
> 
> On Wed, May 26, 2021 at 04:49:16PM -0500, madvenka@linux.microsoft.com wrote:
> > From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> > 
> > The unwinder should check for the presence of various features and
> > conditions that can render the stack trace unreliable and mark the
> > the stack trace as unreliable for the benefit of the caller.
> > 
> > Introduce the first reliability check - If a return PC is not a valid
> > kernel text address, consider the stack trace unreliable. It could be
> > some generated code.
> > 
> > Other reliability checks will be added in the future.
> > 
> > Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> 
> At a high-level, I'm on-board with keeping track of this per unwind
> step, but if we do that then I want to be abel to use this during
> regular unwinds (e.g. so that we can have a backtrace idicate when a
> step is not reliable, like x86 does with '?'), and to do that we need to
> be a little more accurate.

On x86, the '?' entries don't come from the unwinder's determination of
whether a frame is reliable.  (And the x86 unwinder doesn't track
reliable-ness on a per-frame basis anyway; it keeps a per-unwind global
error state.)

The stack dumping code blindly scans the stack for kernel text
addresses, in lockstep with calls to the unwinder.  Any text addresses
which aren't also reported by the unwinder are prepended with '?'.

The point is two-fold:

  a) failsafe in case the unwinder fails or skips a frame;

  b) showing of breadcrumbs from previous execution contexts which can
     help the debugging of more difficult scenarios.

-- 
Josh

