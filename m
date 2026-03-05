Return-Path: <live-patching+bounces-2128-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CDVDB5raqWneGQEAu9opvQ
	(envelope-from <live-patching+bounces-2128-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 20:33:46 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B593C21799D
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 20:33:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EC9813004908
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 19:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06DC8283C9D;
	Thu,  5 Mar 2026 19:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmDrUJ7e"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7598200110
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 19:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772739223; cv=none; b=tkTJYvCZiZHj9EioHAz7JzpcFqQPSLVDAnBfCAEt0izr5cHX3S7m/Kkk/Bl1IA2cq9SDtDsQrVwon3EXxeQSIrAxTZuhG82ZCR/d+/DQodLCpjyqObCeeiaslMLPILEdhTVdaTgA/A/yv+C0/tNaVnNErlm6ZlGBxVVFA5NoUKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772739223; c=relaxed/simple;
	bh=iBozYxR8A0WbJImuhmiEYqvluHPHyYvUUZmkyYv6z+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hicQiorHYmWTtCqEkG8Z3k/HGww80OAyc2ZVdQwGd+fHWHgYRDksByPtQm1hXFCyLmYu7nVFvWfVDTNWOiNU9AQh49fRCK+3Evydea11SOQQp5JEGzNDf4FxeylAZ4itJqRKSXvMeEL6g8I6q+VNEx7KAgmO243D5vJZwwzDqk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmDrUJ7e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B7AC116C6;
	Thu,  5 Mar 2026 19:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772739223;
	bh=iBozYxR8A0WbJImuhmiEYqvluHPHyYvUUZmkyYv6z+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hmDrUJ7ePd4ucB9Fnbsop6nZuxtXLT7+kHiM/U4yolDip4r+zD/5VCH/9iruQ0bWw
	 mD6C98vmCbKqQbEF9xRbGVrrmDzviuK8aDgukV42n4w+TWs/qjw8jUWnmrZ5MzD17T
	 h8E3pkK3J0LobeQ4vt/AtAsRVWUaxqWrzEwVvHeHCN5eK/iXLhLFFNlnQn4qbMV8LX
	 l8hUBpPHFLAhflFHu/QYSqqznpaDgQoJg6EJjCk0bi83zOtXZLTMQ4cLd45QDvDcEk
	 SIknL0uu8m6bqSLn6v+Me1DaggsunOLRozSAZ7P6ME/mACJTPpF+7DeF5rU7/9QbS3
	 XhXhPR6LrWxIg==
Date: Thu, 5 Mar 2026 11:33:41 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
Message-ID: <vb3jhokbri3gn2qoqxubi7ayrkjnhhyhtchalkvyxugt6qyzzi@ym3rwmx7pska>
References: <20260226005436.379303-1-song@kernel.org>
 <20260226005436.379303-9-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260226005436.379303-9-song@kernel.org>
X-Rspamd-Queue-Id: B593C21799D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2128-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 04:54:36PM -0800, Song Liu wrote:
> Add selftests for the klp-build toolchain. This includes kernel side test
> code and .patch files. The tests cover both livepatch to vmlinux and kernel
> modules.
> 
> Check tools/testing/selftests/livepatch/test_patches/README for
> instructions to run these tests.
> 
> Signed-off-by: Song Liu <song@kernel.org>

This patch has some whitespace errors:

/tmp/a:505: space before tab in indent.
 	int i, sum = x;
/tmp/a:506: trailing whitespace.

/tmp/a:507: space before tab in indent.
 	for (i = 0; i < len; i++)
/tmp/a:510: space before tab in indent.
 	if (sum > 1000)
/tmp/a:511: space before tab in indent.
 		sum = 0;
warning: squelched 28 whitespace errors
warning: 33 lines add whitespace errors.


-- 
Josh

