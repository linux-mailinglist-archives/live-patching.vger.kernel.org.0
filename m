Return-Path: <live-patching+bounces-2244-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJH6GwVGvWlZ8gIAu9opvQ
	(envelope-from <live-patching+bounces-2244-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 14:05:09 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C583A2DAA7D
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 14:05:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B0BB7305376A
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 13:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889E13B8BD5;
	Fri, 20 Mar 2026 13:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tLs6Ds1Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jEGp7R2c";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v5uhJJ1b";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N8KDH5XG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823BC3B8D59
	for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 13:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774011816; cv=none; b=IhOfr6FXX199PxgUaZumO1oydHRV/Xsp8rbe1MdPXYKONmjITWJD+zjlSKbaKROUI1ggEPAQ6cdNUUUsA5P7Pj3zeHUqLDlAvSkwAoJFo8zqUpEmKmfswkQtK/V4nRsHpAqfOSf7GollfbeAx5LjYJ2JSzIYkdOcMAlHsc97z9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774011816; c=relaxed/simple;
	bh=GQe2oNyYYkyWVleVjZCPp4jzfbZjFqeuWhBIv6GRsDg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CWqDW7eCycCiNYMjFA7I+3mcKwZNZAj9UHEGhUufGSYX6VEd8WK0RtgNwXBNPsBOfvE8vIYGtnRjY0CasEKhiZ/J4HrncKX9ymozzOYviDaiPcSXYUTXZWJNrpT7D9uf5y3Nflp8dKfVfGrvNI47Dz07LPHlea8FkxE6VLVIgCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tLs6Ds1Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jEGp7R2c; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v5uhJJ1b; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N8KDH5XG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 97D5F4D27A;
	Fri, 20 Mar 2026 13:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774011804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iUBoxoPL/rnJZ/mSDs8ORD2Br0nnMdhpAv6GL1C98ck=;
	b=tLs6Ds1YZlUT1GG4bqhfWvfPvwXU0QyBLFZxEcsJn9QMOxRmc6isd1wnV+CRpZfgylrB0h
	glJHPSZHWf6bWQHZgLspG8IL/jfd6+1+ap6hLSC44YP69lZ8BnKcxMmb9NHwJxWo9pu5Bl
	dFS3kiFlY1O69lmLrURqYJgZrBZoB0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774011804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iUBoxoPL/rnJZ/mSDs8ORD2Br0nnMdhpAv6GL1C98ck=;
	b=jEGp7R2cWu0hyFBILzh+laVPbmoLAU1veAYnjlJDq/iDUHERUT4VYnd0YogRsjPzsI2k7g
	GKTqExQyQbIkcjBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774011801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iUBoxoPL/rnJZ/mSDs8ORD2Br0nnMdhpAv6GL1C98ck=;
	b=v5uhJJ1bibP8VqWRfMsQbjph+JT9uCNWKRJt/2phWTsaJDkkySzErsMPDla1xQcTNjw1da
	O+6124sNke/zRa3Qy2IEOXxYRvgvhQomma+48t4nVEHOysf9rfyewTXiAVTus3PrlmXNxg
	WUkRVWlqc9sGGCw5iKXbtBCbPjXgz5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774011801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iUBoxoPL/rnJZ/mSDs8ORD2Br0nnMdhpAv6GL1C98ck=;
	b=N8KDH5XG3NgERAsd8vfE1lnVFun2fyysaY37BobIpykfwEsXT23VO2HLclkx5D06FOw1QQ
	E6eaKkPWI/EvTnBg==
Date: Fri, 20 Mar 2026 14:03:21 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
    Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] selftests: livepatch: sysfs: Split tests of replace
 attribute
In-Reply-To: <20260313-lp-tests-old-fixes-v1-5-71ac6dfb3253@suse.com>
Message-ID: <alpine.LSU.2.21.2603201358310.12616@pobox.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com> <20260313-lp-tests-old-fixes-v1-5-71ac6dfb3253@suse.com>
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
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2244-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,pobox.suse.cz:mid,test-sysfs.sh:url]
X-Rspamd-Queue-Id: C583A2DAA7D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 13 Mar 2026, Marcos Paulo de Souza wrote:

> In order to run the selftests on older kernels, split the sysfs tests to
> another file, making it able to skip the tests when the attributes
> don't exists.
> 
> No functional changes.

The functional change is that the test does not run older kernels now so I 
would remove the line.

Anyway, I am not entirely happy with carving all three tests out of 
test-sysfs.sh to be honest. Wouldn't it be better to just hide them under 
"if check_sysfs_exists" condition and keep them here? You could make it 
more compact if you check for the sysfs attribute just before checking 
both permissions and values the first time it is accessed.

Miroslav


