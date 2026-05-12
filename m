Return-Path: <live-patching+bounces-2744-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Jx0EZUAA2rdzQEAu9opvQ
	(envelope-from <live-patching+bounces-2744-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 12:27:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A5D51E87C
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 12:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4CBB4300C817
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 10:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93732395AD2;
	Tue, 12 May 2026 10:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RmkRaQVb"
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10D95395AC5;
	Tue, 12 May 2026 10:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778581134; cv=none; b=iZPo0gyX35I3YrOOmUcyh5AWg66qhdpLMaBS6dx5vOzf9+1VK6C1dMBGKz9vW68/yfG095rmEvjpn1hWG3WPJi7Bul4hktGdPiXqgNpt+eMHBQF4ia7drVIC9offzY01muYpfRH/LXfvxOiNtYKbpQtEsw9iLZ2gt5lBzp4Kz9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778581134; c=relaxed/simple;
	bh=U2RKyZFvAJWxf0WCPY/QD6ZBjPhpAW6Y7NJlEYh5m/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=scMegkAMpDlsBMbdg7YqXwt8aCAUhgxVpHz3PHAn+e6T7ZO2ON4fP0hF8Wj71+OPdnlegetDigwrElHlRulHmzZgmKngWI6jRnw53FD4sebeyajHnUvM/02vtwJtizV9O+xnUa7l7hV4eEa8hyHw36LyykG3OnzI3CwYVj8Xzmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RmkRaQVb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEDAA1691;
	Tue, 12 May 2026 03:18:46 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 801993F7B4;
	Tue, 12 May 2026 03:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778581132; bh=U2RKyZFvAJWxf0WCPY/QD6ZBjPhpAW6Y7NJlEYh5m/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RmkRaQVb1rWl0nZAhjmin3dPinyheV0A8H6NPKwNRAZSkz2kDu9erVlPzr8cWejjx
	 RDLHH9k5kuVsFreX56A1KXFJv2KL5a9CTuEm5c+q8PYmn3rHwQsDEq+6LZG6BLvC19
	 AYqYCePgiYB+a6VmXItxNpzJIusKvB7sDCbP+mKY=
Date: Tue, 12 May 2026 11:18:45 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Indu Bhagat <ibhagatgnu@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jiri Kosina <jikos@kernel.org>,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
	joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v5 8/8] unwind: arm64: Use sframe to unwind interrupt
 frames
Message-ID: <agL-hacT_xeh1kmz@J2N7QTR9R3>
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-9-dylanbhatch@google.com>
 <afTYzAF_x41pyilu@J2N7QTR9R3>
 <CADBMgpx9YxNUO6wLP7mYKxWW8L78Hk9gPwHrMjXUwPyUmGEu9w@mail.gmail.com>
 <0542f042-14fb-4588-bc3a-5031249d9834@linux.ibm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0542f042-14fb-4588-bc3a-5031249d9834@linux.ibm.com>
X-Rspamd-Queue-Id: B1A5D51E87C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=foss];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2744-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[google.com,linux.dev,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org,linux.ibm.com];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	DKIM_TRACE(0.00)[arm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mark.rutland@arm.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Tue, May 12, 2026 at 10:55:28AM +0200, Jens Remus wrote:
> On 5/12/2026 5:00 AM, Dylan Hatch wrote:
> > On Fri, May 1, 2026 at 9:46 AM Mark Rutland <mark.rutland@arm.com>
> > wrote:
> 
> >> (1) For correctness, we'll need to address a latent issue with
> >> unwinding across an fgraph return trampoline, where the return
> >> address is transiently unrecoverable.

> >> I think we can solve that with some restructuring of that code, 
> >> restoring the original address *before* removing that from the 
> >> fgraph return stack, and ensuring that the unwinder can find it.
> > 
> > If my understanding is correct, the issue arrises in
> > return_to_handler as the return address is recovered:
> > 
> > mov x0, sp bl ftrace_return_to_handler // addr =
> > ftrace_return_to_hander(fregs); mov x30, x0 // restore the original
> > return address
> > 
> > Because ftrace_return_to_handler pops the return address from the 
> > return stack before it can be restored into the LR, it cannot be 
> > recovered.
> 
> Based on reliable-stacktrace.rst section "4.4 Rewriting of return
> addresses" I wonder whether the following might work:
> 
> - If an unwound RA points at return_to_handler the actual RA needs to
>   be obtained using ftrace_graph_ret_addr().  This might already be
>   taken into account if ftrace_graph_ret_addr() is used unconditionally.
> 
> - If an unwound RA points into return_to_handler() mark the stack trace
>   as unreliable.  This could be accomplished by marking LR in
>   return_to_handler() as undefined (i.e. .cfi_undefined 30) to use
>   SFrame's outermost frame indication to stop and mark the stack trace
>   as unreliable:

We don't currently have any CFI annotations for return_to_handler(), so
if we interrupt that, any unwind will naturally be marked as unreliable.

The problem is that we can try an unwind from an interrupted *callee* of
return_to_handler(). In that case, we'll unwind through
return_to_handler() using the frame pointer, without consulting SFrame.
In that case, the PC will be part-way through return_to_handler(), but
we only call ftrace_graph_ret_addr() when the PC is the start of
return_to_handler, and so we don't even try to recover the return
address.

We can handle that better by checking whether the PC is *within*
return_to_handler(), and aborting when the original return address
cannot be recoverted. I'm happy to go put that together, nad longer term
I would like to do the better reovery I described above such that we can
*always* recover the return address.

Mark.

