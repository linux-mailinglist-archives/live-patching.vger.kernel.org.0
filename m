Return-Path: <live-patching+bounces-645-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5459F973AE8
	for <lists+live-patching@lfdr.de>; Tue, 10 Sep 2024 17:03:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8688C1C25277
	for <lists+live-patching@lfdr.de>; Tue, 10 Sep 2024 15:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D528199923;
	Tue, 10 Sep 2024 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EXYKx3vg"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C847D6F305
	for <live-patching@vger.kernel.org>; Tue, 10 Sep 2024 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725980592; cv=none; b=K9rPQVmeSLLh6TzAhSDOif4N5Dr8C+pwTlsyudN2yluNp56x0uCGU3qJUCTWPuPmJJz7JyE8L4efzJBjGGmrN2pxXHq/8c3Yc/PLT+mfW1gQk0mwftbyH6xMoGjQoHwiN4MgLLDMo+nt0sqI3/2iTILRp9TCvRMj0Hu/ZpGBBk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725980592; c=relaxed/simple;
	bh=94MZ08KGJV5zYWbEnAHBlRQX5djgCiqkeislAoXIDMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQg0gAQn3a5PNxtJKllmEJbUmOGb9UgU7T+LbBZv4s7dPEkKCWHt7WBgPORpWvl48+a6g8o1aLnXjUccUm4Muv8nIvwSjnrQEUoDwQ4PEQXiJnLPovLFeDH+jOJg+vtFNm/WaRWnFmGboooLaDLkyQcYoiioRaFpb3na0SKBc5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EXYKx3vg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725980589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NOLWN6oOPgomGiBhn0K1y3N/9IV4oAwOhduq7A0XQxo=;
	b=EXYKx3vgxukmOh1ETSupn/8FUuvIwI1a6NGcOS0GWdZw66nRLq6bW8dV6A2aUV+Sd8At8H
	yA+SufEeJCPMYlhTwg4LNmj5aOqU31pEwaQQR6ZGTbv2m82EWsK2ZA6ppDUPVGkuc7Ffan
	ni9C04jfY08tB4yR67SiSpJlRcv/9bg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-434-v5mO4rvmMZWgMKfgizrC4w-1; Tue,
 10 Sep 2024 11:03:04 -0400
X-MC-Unique: v5mO4rvmMZWgMKfgizrC4w-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4CFEA195395E;
	Tue, 10 Sep 2024 15:03:02 +0000 (UTC)
Received: from sullivan-work (unknown [10.22.65.47])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E439830001A1;
	Tue, 10 Sep 2024 15:02:58 +0000 (UTC)
Date: Tue, 10 Sep 2024 11:02:56 -0400
From: "Ryan B. Sullivan" <rysulliv@redhat.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, pmladek@suse.com, mbenes@suse.cz,
	jikos@kernel.org, jpoimboe@kernel.org, naveen.n.rao@linux.ibm.com,
	christophe.leroy@csgroup.eu, npiggin@gmail.com
Subject: Re: [PATCH] powerpc/ftrace: restore r2 to caller's stack on
 livepatch sibling call
Message-ID: <ZuBfoBKUejKLlV5c@sullivan-work>
References: <87ed6q13xk.fsf@mail.lhotse>
 <20240815160712.4689-1-rysulliv@redhat.com>
 <9ec85e72-85dd-e9bc-6531-996413014629@redhat.com>
 <Zt8jaSQjpwtfJaVx@sullivan-work>
 <87bk0wrn1m.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bk0wrn1m.fsf@mail.lhotse>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Sep 10, 2024 at 05:21:57PM +1000, Michael Ellerman wrote:
> "Ryan B. Sullivan" <rysulliv@redhat.com> writes:
> > Hello all,
> >
> > Just wanted to ping and see if there was any further feedback or
> > questions regarding the patch?
> 

Hi Michael,

Thank you for the update.

> Hi Ryan,
> 
> I'd really like a selftest that triggers the sibling call behaviour.
> 
> As I said upthread I tried writing one but failed. Which you later
> explained is because the cross-module sibling call is not generated by
> the compiler but rather by the code being objcopy'ed (or similar).
> 
> I think it should be possible to trick the compiler into letting us do a
> cross-module sibling call by doing it in an inline asm block. Obviously
> that's non-standard, but I think it might work well enough for a test?
> 
> We have an example of calling a function within an inline asm block in
> call_do_irq().

If you think that that would be a welcome addition to the patch I can
look into adding it, especially if you are busy at the moment.

> 
> I'll try to find time to get that done, but I can't promise when.
> 
> cheers
> 

Cheers,

Ryan


