Return-Path: <live-patching+bounces-2095-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MDBzDlBtoWm6swQAu9opvQ
	(envelope-from <live-patching+bounces-2095-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 27 Feb 2026 11:09:20 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C53E1B5D29
	for <lists+live-patching@lfdr.de>; Fri, 27 Feb 2026 11:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1A75530F6CDB
	for <lists+live-patching@lfdr.de>; Fri, 27 Feb 2026 10:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5BBC33BBA7;
	Fri, 27 Feb 2026 10:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zM034byu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="B0XD/yVs";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zM034byu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="B0XD/yVs"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3691F35A3A6
	for <live-patching@vger.kernel.org>; Fri, 27 Feb 2026 10:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772186702; cv=none; b=HSk8ecZgMfx9l8nsHd2uuFBXxP6POXRD8VScPGyT+P3CN42ODb7LtD1OhJBNDPpr9iFmmywEy15RIOJgp3VR1Xnete0M6fnuVscMr1ACE4qHl/ZK831IU9T8efZ4mMTsqh6dcj7EN1SHBWHxHF2/5rsUm+CULngA2RdTCEMrD1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772186702; c=relaxed/simple;
	bh=7h8q1dFL6OBFLLEi5O+QHcaJpC79aLv9MXz908Vm/fE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DWdElMosKz7dZG0qi3159V83F9FxxHYpjBU59xJWkAKFgO3OKFyOg8fZgRu4Za2GFqH0DBmNys8NTX0BF6D1fAlcLJcPR2FcNw7GlEPnTM0zMOh/fYmEy8uu8xihR8zFmCWsdg9AY1l3rVkIuhaUKXidR7b34Y1un2P0vpm3PSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zM034byu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=B0XD/yVs; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zM034byu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=B0XD/yVs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3E2CF3F839;
	Fri, 27 Feb 2026 10:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772186699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gZRx7/gkXFjhxxkPKxEsLripLJrnl5ZHkRkECzla+So=;
	b=zM034byutdQmhNMyJo/QtTQDkgDzl+ExejvCAv4/wEVJlnbXSdt18NuwM6PrUlMQx8oHe2
	7Nk91YINO4u8thYa8LocjmrDPcsXacyP0LxH5nNd3z1hXQDcAy+US3V/LB7aTQ0JBTBr64
	dh5qJ7Ujz9khb2q42DquOmSRAIC6Hsg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772186699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gZRx7/gkXFjhxxkPKxEsLripLJrnl5ZHkRkECzla+So=;
	b=B0XD/yVs5srQUSZ5XWQ2CWs+a6rZTwo+4mwT7FmezBseUCGxUQZds9h/1sKpxfR9ZUiEK1
	j1c+XtDge1wdlADA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772186699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gZRx7/gkXFjhxxkPKxEsLripLJrnl5ZHkRkECzla+So=;
	b=zM034byutdQmhNMyJo/QtTQDkgDzl+ExejvCAv4/wEVJlnbXSdt18NuwM6PrUlMQx8oHe2
	7Nk91YINO4u8thYa8LocjmrDPcsXacyP0LxH5nNd3z1hXQDcAy+US3V/LB7aTQ0JBTBr64
	dh5qJ7Ujz9khb2q42DquOmSRAIC6Hsg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772186699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gZRx7/gkXFjhxxkPKxEsLripLJrnl5ZHkRkECzla+So=;
	b=B0XD/yVs5srQUSZ5XWQ2CWs+a6rZTwo+4mwT7FmezBseUCGxUQZds9h/1sKpxfR9ZUiEK1
	j1c+XtDge1wdlADA==
Date: Fri, 27 Feb 2026 11:04:59 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Liu <song@kernel.org>
cc: live-patching@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org, 
    pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
In-Reply-To: <20260226005436.379303-9-song@kernel.org>
Message-ID: <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz>
References: <20260226005436.379303-1-song@kernel.org> <20260226005436.379303-9-song@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2095-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8C53E1B5D29
X-Rspamd-Action: no action

Hi,

I have a couple of questions before reviewing the code itself. See below. 
I removed the code completely as it seems better to have it compact. Sorry 
if it is too confusing in the end and I apologize for being late to the 
party. We can always merge the first 7 patches when they are settled and  
keep this one separate.

On Wed, 25 Feb 2026, Song Liu wrote:

> Add selftests for the klp-build toolchain. This includes kernel side test
> code and .patch files. The tests cover both livepatch to vmlinux and kernel
> modules.
> 
> Check tools/testing/selftests/livepatch/test_patches/README for
> instructions to run these tests.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> 
> ---
> 
> AI was used to wrote the test code and .patch files in this.

This should go to the changelog directly. See new 
Documentation/process/generated-content.rst.

> ---
>  kernel/livepatch/Kconfig                      |  20 +++
>  kernel/livepatch/Makefile                     |   2 +
>  kernel/livepatch/tests/Makefile               |   6 +
>  kernel/livepatch/tests/klp_test_module.c      | 111 ++++++++++++++
>  kernel/livepatch/tests/klp_test_module.h      |   8 +
>  kernel/livepatch/tests/klp_test_vmlinux.c     | 138 ++++++++++++++++++
>  kernel/livepatch/tests/klp_test_vmlinux.h     |  16 ++
>  kernel/livepatch/tests/klp_test_vmlinux_aux.c |  59 ++++++++
>  .../selftests/livepatch/test_patches/README   |  15 ++
>  .../test_patches/klp_test_hash_change.patch   |  30 ++++
>  .../test_patches/klp_test_module.patch        |  18 +++
>  .../klp_test_nonstatic_to_static.patch        |  40 +++++
>  .../klp_test_static_to_nonstatic.patch        |  39 +++++
>  .../test_patches/klp_test_vmlinux.patch       |  18 +++
>  14 files changed, 520 insertions(+)
>  create mode 100644 kernel/livepatch/tests/Makefile
>  create mode 100644 kernel/livepatch/tests/klp_test_module.c
>  create mode 100644 kernel/livepatch/tests/klp_test_module.h
>  create mode 100644 kernel/livepatch/tests/klp_test_vmlinux.c
>  create mode 100644 kernel/livepatch/tests/klp_test_vmlinux.h
>  create mode 100644 kernel/livepatch/tests/klp_test_vmlinux_aux.c
>  create mode 100644 tools/testing/selftests/livepatch/test_patches/README
>  create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_hash_change.patch
>  create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_module.patch
>  create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_nonstatic_to_static.patch
>  create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_static_to_nonstatic.patch
>  create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_vmlinux.patch

We store test modules in tools/testing/selftests/livepatch/test_modules/
now. Could you move klp_test_module.c there, please? You might also reuse 
existing ones for the purpose perhaps.

What about vmlinux? I understand that it provides a lot more flexibility 
to have separate functions for testing but would it be somehow sufficient 
to use the existing (real) kernel functions? Like cmdline_proc_show() and 
such which we use everywhere else? Or would it be to limited? I am fine if
you find it necessary in the end. I just think that reusing as much as 
possible is generally a good approach.

The patch mentiones kpatch in some places. Could you replace it, please?

And a little bit of bikeshedding at the end. I think it would be more
descriptive if the new config options and tests (test modules) have 
klp-build somewhere in the name to keep it clear. What do you think?

Thanks for the patches!

Miroslav


