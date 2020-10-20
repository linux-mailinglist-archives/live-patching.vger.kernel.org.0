Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8576B29407D
	for <lists+live-patching@lfdr.de>; Tue, 20 Oct 2020 18:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394620AbgJTQ2T (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Oct 2020 12:28:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394610AbgJTQ2S (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Oct 2020 12:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603211297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GU9njVdqHucbt2KcXKmLskXulruliQZ22ngpTKfTF4g=;
        b=GDj/1iiXWnX5en2EKlRvBMe9j5MMcnLinM23w/2z3NIBgonn8UDyAXUlZ4qoAtQ/wY+BDc
        bkRnRfbaqJurHjTX29CCRqkJOMZVsCJLt/V4knfzer+jJxptFMcCH97dyYcsH2Y+nSKvwV
        Lw7ws7KP+bdreD//y89oT8mXUmymyiI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334--84pZLXgMUu-r8P4wkT6pA-1; Tue, 20 Oct 2020 12:28:13 -0400
X-MC-Unique: -84pZLXgMUu-r8P4wkT6pA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13F7E1084C88;
        Tue, 20 Oct 2020 16:28:12 +0000 (UTC)
Received: from treble (ovpn-118-22.rdu2.redhat.com [10.10.118.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB0EB5B4A3;
        Tue, 20 Oct 2020 16:28:09 +0000 (UTC)
Date:   Tue, 20 Oct 2020 11:28:06 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] arm64: Implement reliable stack trace
Message-ID: <20201020162806.6kl6japxkij7dzel@treble>
References: <20201012172605.10715-1-broonie@kernel.org>
 <alpine.LSU.2.21.2010151533490.14094@pobox.suse.cz>
 <20201015141612.GC50416@C02TD0UTHF1T.local>
 <20201015154951.GD4390@sirena.org.uk>
 <20201015212931.mh4a5jt7pxqlzxsg@treble>
 <20201016121534.GC5274@sirena.org.uk>
 <20201019234155.q26jkm22fhnnztiw@treble>
 <20201020153913.GE9448@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201020153913.GE9448@sirena.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Oct 20, 2020 at 04:39:13PM +0100, Mark Brown wrote:
> On Mon, Oct 19, 2020 at 06:41:55PM -0500, Josh Poimboeuf wrote:
> > On Fri, Oct 16, 2020 at 01:15:34PM +0100, Mark Brown wrote:
> 
> > > Ah, I'd have interpreted "defined thread entry point" as meaning
> > > expecting to find specific functions appering at the end of the stack
> > > rather than meaning positively identifying the end of the stack - for
> > > arm64 we use a NULL frame pointer to indicate this in all situations.
> > > In that case that's one bit that is already clear.
> 
> > I think a NULL frame pointer isn't going to be robust enough.  For
> > example NULL could easily be introduced by a corrupt stack, or by asm
> > frame pointer misuse.
> 
> Is it just the particular poison value that you're concerned about here
> or are you looking for additional checks of some other kind?

You just need to know you've conclusively reached the user entry point
on the stack, without missing any functions.

A sufficiently unique poison value might be ok.  Though, defining a
certain stack offset as the "end" seems more robust.

-- 
Josh

