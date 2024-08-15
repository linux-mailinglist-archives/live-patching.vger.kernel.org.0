Return-Path: <live-patching+bounces-495-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BBAB9952CA3
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 12:44:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA65C1C22704
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 10:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ADFF19D068;
	Thu, 15 Aug 2024 10:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="r9W0oxFI"
X-Original-To: live-patching@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C7B1BB6B5
	for <live-patching@vger.kernel.org>; Thu, 15 Aug 2024 10:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723717342; cv=none; b=F/fOjly3wntBpFWkgxGrvjq/yOlmWw7G3/M0dX6rdenIcGvQgByBHvUH3U/Ady1cJST/v/yIlLxBOshVavYo8mWFGjkw5xVXQZW8yN+xS0eHqgAec5guxQv4++NsuMZj4clT6o4UK71BkUe+8iyl84BEI0w1Kp0mb5eIiuyCH3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723717342; c=relaxed/simple;
	bh=EWxKiICgYw457W0OxIAbS4ICNjCgsrxlUPJj1DSYvMA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LaphpYbJLIcdi02XfyPsrmoGvbcKsdwr/yHdpvoXbGk9CB0iUCPEGuooXxtPvC8PQmI36I4hlZ3hEygbFBWi/QGP1t6FiHWAl8Jsse6X9BvUc7vb+Hf2UTJanK4LKr94ErQONs8O6BruyRB0P1c7fckimrTAo6TdqLfeUIeYZGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=r9W0oxFI; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1723717337;
	bh=EWxKiICgYw457W0OxIAbS4ICNjCgsrxlUPJj1DSYvMA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=r9W0oxFI3PMSbGzqzdAAZOWA+0y5W+GtaV7IId3LEmP9+lPytcuqu0YwsROHNaaAy
	 p5y9KSp0ll1m/379CbaySg0yzpTV2PtlhfSvheyKkMD+UQijvfglaiJttpfDUYLCaD
	 P6GJPUy5/kZOpUhr6o9sJMIhac6xVLPSO0in4uDBJ3ugjTzCP9YiiYOdE6+7++ON5j
	 n5kvFN5VvaxMMrqQo2oLQohGdkc1KSz7BLmUV/bxPvUXNBOetWOU+dt+D45teEPXjL
	 YCAueunI1hokOjOjsO/EvCji/xWzq6BJA+ibEE1TfwetYjsB/CtCA9ZaN92ekmRGTS
	 f/4o6JwYZ8mwA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Wl1QJ4WHZz4wp0;
	Thu, 15 Aug 2024 20:22:16 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Ryan Sullivan <rysulliv@redhat.com>, live-patching@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
Cc: rysulliv@redhat.com, joe.lawrence@redhat.com, pmladek@suse.com,
 mbenes@suse.cz, jikos@kernel.org, jpoimboe@kernel.org,
 naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu, npiggin@gmail.com
Subject: Re: [PATCH] powerpc/ftrace: restore r2 to caller's stack on
 livepatch sibling call
In-Reply-To: <20240729150246.8939-1-rysulliv@redhat.com>
References: <878qxkp9jl.fsf@mail.lhotse>
 <20240729150246.8939-1-rysulliv@redhat.com>
Date: Thu, 15 Aug 2024 20:22:15 +1000
Message-ID: <87ed6q13xk.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ryan Sullivan <rysulliv@redhat.com> writes:
> Hello Michael,
>
> In the case of no sibling call within the livepatch then the store is
> only "restoring" the r2 value that was already there as it is stored
> and retrieved from the livepatch stack.

But what guarantee do we have that it's the value that was already
there?

Notice that the current livepatch_handler doesn't store to the (normal)
stack at all, because it doesn't know the context it's called in.

Does kpatch do anything special to induce the sibling call? Is it doing
objcopy or anything else weird?

I tried writing a selftest (in tools/testing/selftests/livepatch) to
trigger this case but couldn't get it to work. The compiler never
generates a sibling call across modules.

cheers

