Return-Path: <live-patching+bounces-1132-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 986C4A2CA92
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 18:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C02771887A99
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 17:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF43198A19;
	Fri,  7 Feb 2025 17:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G40TBqV1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6ED8479;
	Fri,  7 Feb 2025 17:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738950775; cv=none; b=mYxpyfL1El2qNKpDz4jCZaKFHvYxHSUT//EbZiRkQjdU9Yeif9cOQCL5y9ITfYx/GDDd4Df3CNKdiVtOtdal5y+8H8HrEeCrPnWwYawcxdxY/3xBIuWXF56N8WTPmorSY8kUFhr9iMuVmcBO2554nXX6XQrKPLTYBCVf5E2sV40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738950775; c=relaxed/simple;
	bh=o7WL3rojOnZteVHaXqfHStpkFhdgk+b0ovUxVviMNXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LF1qYheVfJN2f3NsbX1giCBWfjxQ61iP2Pb8rvCtQrIhHqGx0tb+zESp2lkKM+D8K1BhiSr9EmmPOYbCmOClQ9oAQ1DrWJWBIlnPSNPzC8Vw6gI7Nr2hsHzwis3A0hV59Gz9TFj67gPno/GC1uZoOF3Q0N1yoIZMmoqAxisg3Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G40TBqV1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D52C4CED1;
	Fri,  7 Feb 2025 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738950774;
	bh=o7WL3rojOnZteVHaXqfHStpkFhdgk+b0ovUxVviMNXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G40TBqV1iOeetam5qpFi3xZs0wRJjQws8L0f8wwMs7uRHkjDRWs1fzI/pB4PdJgxo
	 qpCGqWEq02xMTTrow+jjp6zEyegQ9cL5WZfavmKDK9+67ajyf4v5ZGvX05aWD3cG+1
	 oQR2BU7Gaaw7D1dlP21wzupMrNYGnNeQ+PmRddAdqI0De8HLOxp6aazIjHtrgga0Py
	 V9NpsPHmTNEXO1BOkwVk9J2WHEWTX3gwASbcaLwH4Y4MTvvVRGtJ/NIPE9gA0iawE5
	 C0XXs8m3lk/E+u+7P5LyNbjG8OX1sTZ2PmlbD33flwqsdbVEHtuPNeIdgGorYXKbVh
	 Re8DBUsIAP5ww==
Date: Fri, 7 Feb 2025 09:52:52 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Puranjay Mohan <puranjay@kernel.org>
Cc: Weinan Liu <wnliu@google.com>, indu.bhagat@oracle.com,
	irogers@google.com, joe.lawrence@redhat.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org,
	mark.rutland@arm.com, peterz@infradead.org,
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <20250207175252.wtsfjqnm52jkevog@jpoimboe>
References: <mb61pwme55kuw.fsf@kernel.org>
 <20250206150212.2485132-1-wnliu@google.com>
 <mb61pikpm3q76.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <mb61pikpm3q76.fsf@kernel.org>

On Fri, Feb 07, 2025 at 12:16:29PM +0000, Puranjay Mohan wrote:
> Weinan Liu <wnliu@google.com> writes:
> > Thank you for reporting this issue.
> > I just found out that Josh also intentionally uses '>' instead of '>=' for the same reason
> > https://lore.kernel.org/lkml/20250122225257.h64ftfnorofe7cb4@jpoimboe/T/#m6d70a20ed9f5b3bbe5b24b24b8c5dcc603a79101
> >
> > QQ, do we need to care the stacktrace after '__noreturn' function?
> 
> Yes, I think we should, but others people could add more to this.

FYI, here's how ORC handles this:

	/*
	 * Find the orc_entry associated with the text address.
	 *
	 * For a call frame (as opposed to a signal frame), state->ip points to
	 * the instruction after the call.  That instruction's stack layout
	 * could be different from the call instruction's layout, for example
	 * if the call was to a noreturn function.  So get the ORC data for the
	 * call instruction itself.
	 */
	orc = orc_find(state->signal ? state->ip : state->ip - 1);

and state->signal is only set for exceptions/interrupts (including
preemption and page faults) and newly forked tasks which haven't run
yet.

-- 
Josh

