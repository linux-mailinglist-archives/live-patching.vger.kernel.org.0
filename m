Return-Path: <live-patching+bounces-1961-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAxRGefqgGleCAMAu9opvQ
	(envelope-from <live-patching+bounces-1961-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 19:20:23 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BA154D012B
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 19:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B90503004427
	for <lists+live-patching@lfdr.de>; Mon,  2 Feb 2026 18:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9682E040E;
	Mon,  2 Feb 2026 18:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MbY4Qk8N"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F532DC35A;
	Mon,  2 Feb 2026 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770056416; cv=none; b=BpM1pa6KNKoreqvnZpvItzOCkABut+h1UENGhuCFybleJLl76L2/4/FwWJYxpgLr/Q9DZb2qRxmZhR5c9IcATF24a3E3HJ9/OS7MZfp5tpVUYnbFBhOIcgFwnz7HmJ316bdN0HvkJ+ukwjNU+MUr6jnGZVOTa23dSGwiPS1t1Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770056416; c=relaxed/simple;
	bh=JvcLqOXxggLXpyfEo+qtZTQLnmpF4JeHB+JQEuCwyJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pfRK33bjpszQUkPSbigwtp9v2FGJywl2ELuTlNm+fFAuPSlNe6pVtFx/1DyT1Lmu7VmR6ADPoW2MQ08YKRDOg6K9h9a+wPloh17qnLBTZ9O6w6VxMzihObjHjIhUdSR9jc33Bzsk3cOB7q5cP3QiRCCGdPVgfdg8SHo/Ue2R5K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MbY4Qk8N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66448C116C6;
	Mon,  2 Feb 2026 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770056415;
	bh=JvcLqOXxggLXpyfEo+qtZTQLnmpF4JeHB+JQEuCwyJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MbY4Qk8NM/SYBvkwRdaf+EwTE76/wbJQFwzJxQkyBW/dijOFGLG3r1xtqC8hhH4nU
	 zM86pnvpYplr0JL7m733JtMizzB4NvEvq237F/SimvkYeCIV4hrxRyusET2SLmIHYd
	 3XWas0HW4NBRz8iDG9GpPcvTJP9YlVgddupJZmNM8NlIFyYjjchbJkMLl7Y/T64uLN
	 4QCtpWdlmgjOLnf29qkzXwv7LpDPLv9uUaHGUXdm0SeHuClnd0LQVGKY6sMjG8Wna5
	 dRJi0WPmrb/8HNgN2/18xqVyhrRZcl59BHThjNptcpt3uNsm8uPXhAYWgsC7Ygfp92
	 Af2rIf6qVlbCg==
Date: Mon, 2 Feb 2026 10:20:13 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: objtool: static_call: can't find static_call_key symbol:
 __SCK__WARN_trap
Message-ID: <puebtzhzzstmcdufv3deh2twxflheqf6b6opkmw4rfjfua67ns@gbkkboyglhpt>
References: <99f7cfd4-ef1a-4da6-842f-19429b1fb2d2@app.fastmail.com>
 <dbbcybceshl7xlj2qujmo6s2vha7oqvp6bqcir5jfjae7h2z7b@iy4uzb2ygunj>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dbbcybceshl7xlj2qujmo6s2vha7oqvp6bqcir5jfjae7h2z7b@iy4uzb2ygunj>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1961-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BA154D012B
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 10:19:33AM -0800, Josh Poimboeuf wrote:
> On Mon, Feb 02, 2026 at 05:18:13PM +0100, Arnd Bergmann wrote:
> > Hi,
> > 
> > I see a new objtool related build failure on current linux-next
> > with clang-21:
> > 
> > samples/livepatch/livepatch-shadow-fix1.o: error: objtool: static_call: can't find static_call_key symbol: __SCK__WARN_trap
> > 
> > I couldn't figure out what exactly is going on there, this seems fine
> > with gcc, and so far only one of hundreds of configs has this issue.
> > 
> > See the attachments for .config and the object file.
> 
> Ah, this is CONFIG_MEM_ALLOC_PROFILING_DEBUG inserting a WARN() in the
> sample livepatch module's memory allocation, triggering the following
> warning (file->klp is true):
> 
> 		if (!key_sym) {
> 			if (!opts.module || file->klp) {
> 				ERROR("static_call: can't find static_call_key symbol: %s", tmp);
> 				return -1;
> 			}
> 
> 
> So this is showing that the sample livepatch modules (which are built
> differently from the new klp-build way of building livepatch modules)
> will fail to build when trying to access a non-exported static key.

Erm, non-exported static *call*.

-- 
Josh

