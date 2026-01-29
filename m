Return-Path: <live-patching+bounces-1929-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6IhFFyaie2nOGAIAu9opvQ
	(envelope-from <live-patching+bounces-1929-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 29 Jan 2026 19:08:38 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DF79CB3632
	for <lists+live-patching@lfdr.de>; Thu, 29 Jan 2026 19:08:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C277300A3BA
	for <lists+live-patching@lfdr.de>; Thu, 29 Jan 2026 18:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A1D334C10;
	Thu, 29 Jan 2026 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPg9jM3c"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062002D46B3
	for <live-patching@vger.kernel.org>; Thu, 29 Jan 2026 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769710116; cv=none; b=iVRBCTPP8Ys6mLPlK0bfViXlRh2u35L8crhaVxxbtc3uI8VvdM94q8/TVsS4dA5928rFv/sBZrzTS4t3yAW/ahjOW7w+Epc2NRXGhg3SHYsSpcxgVVqpJq+zbFLfuI3fp6/j6bUv7I9K0obERjlTDa8oZtjSFJ8otd8X8gS3TtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769710116; c=relaxed/simple;
	bh=SS57QMHe5f9qhlh7BPrZYji0zRw10WiOjNiRT6n2CUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IIWeR/JBZeWtS0Qy+i2eQmod1Tiz2bh3QZNb3fXIzEj4RSLOWJZ8sL6GGx3+VJFlGBpEx1YSDdIZQI1IgeRe5axJoaM8suwVDeslVg4w4i9i8eyS90er1RIjyjvcqgdrcZ/nnDJDyzNS4abo0wg07v4VGWX7hRbUNBcBmxCRyow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPg9jM3c; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C1FC4CEF7;
	Thu, 29 Jan 2026 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769710115;
	bh=SS57QMHe5f9qhlh7BPrZYji0zRw10WiOjNiRT6n2CUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hPg9jM3cv+sxC4V0Tr9SNCTKpoXmixZ+wPOzIJBKrI87mlH01nsS9L8cN/vEOImkk
	 ueN2tIsACaJPcl8bTyWyiO8O8ABiL/AHeZwFRctKhmUErQyq4voSflL5j1gQdHcPej
	 x8/F084vsD42aOfgHPwqE5VY3m6De91NiCZzcfqMqiCfTun+F5b5/rrcwVicQx2JRV
	 uf+PQ8RPS5aa67+Yu/q7kqbYmY8aeb5Of4c+LB6qgA9jsP/EgFZtqKeK4C4ci4ZYtx
	 RL4vlzl7rxx4dKRzIbOjy338NYIwPhWoGaPVysiMTnHZ3h8Yn7Mcqb2cTVFi+ZlIDH
	 N8ZWLjWHmq4Sg==
Date: Thu, 29 Jan 2026 10:08:33 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, kernel-team@meta.com, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com
Subject: Re: [PATCH] klp-build: Support clang/llvm built kernel
Message-ID: <mt6sjhz5ydcxnp5jqlq3il4th65zevwrw4ihsnkcnuln6czvul@ljlgziem2eqs>
References: <20260129170321.700854-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260129170321.700854-1-song@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1929-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DF79CB3632
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 09:03:21AM -0800, Song Liu wrote:
> When the kernel is built with clang/llvm, it is expected to run make
> with "make LLVM=1 ...". The same is needed when building livepatches.
> 
> Use CONFIG_CC_IS_CLANG as the flag to detect kernel built with
> clang/llvm, and add LLVM=1 to make commands from klp-build
> 
> Signed-off-by: Song Liu <song@kernel.org>

Indeed, I had tested by exporting LLVM=1, but this is better...  Thanks!

-- 
Josh

