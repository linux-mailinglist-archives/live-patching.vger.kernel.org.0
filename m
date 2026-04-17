Return-Path: <live-patching+bounces-2379-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uI5WMPzs4WmKzgAAu9opvQ
	(envelope-from <live-patching+bounces-2379-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 10:19:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 14FD2418859
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 10:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5305B3003308
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 08:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D153126C0;
	Fri, 17 Apr 2026 08:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bsyX0P+4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WxZpBaET";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bsyX0P+4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WxZpBaET"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BBE33AD9D
	for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 08:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776413617; cv=none; b=pZOydXcw5d3dkVC5ULE9gEGEI+NXmQStGcDrc8xIEk3YSiCp31olY/+SGpKKuXhmm4d890pi4exblxD6QE63nhUPdTN+JHUJUN0BVwaJOO3UsYm5w3J4iLhYhDfT2MJG2UxUo6e8G7vKYh+E2hBRktWHiUdf6Q80rN1wmHGY/ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776413617; c=relaxed/simple;
	bh=WIZMCfEdo5EVXILpHoavBd/cCsHFuLHcye+gnRWqtlk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XWVA3qRoC/esrb+bij9kv5Nr7wro+uteyrOfvIZATUIa42BOLiBZ/wR+mPFwyBbvYj/N6Yr32BhrJAjznHgZ1hScoITs4UtUYfebZ1Jrufe9CdJmm6UKfN4hbZBhLD4YNNvyCxXj2moqIvX6HfwT285qIIMLt7DREB7eJGAKz9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bsyX0P+4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WxZpBaET; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bsyX0P+4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WxZpBaET; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 706056A985;
	Fri, 17 Apr 2026 08:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776413614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TgbWk4XqXibZ4hp/e5YWk8D3E7kXbfcnOBDxRNOXiWw=;
	b=bsyX0P+4XR7qNF/IYxj8px/ezJcKUnujfKV44YCNx1JdLCnwQzP8Zo0UOz5HzoBZafKasg
	XRudMX/jh2nHdoEQLtw9+lhP+3fIuhNCNMFMV1Ciih79L9lnZ7ykpqai2PRUWjWes5QTRd
	MYHIOaqYN1KBgqhLOm4zbJKDQkJMovw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776413614;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TgbWk4XqXibZ4hp/e5YWk8D3E7kXbfcnOBDxRNOXiWw=;
	b=WxZpBaETIPfo3K5YBgEYZY2CoT4rnAg+FKWvjRp2vw1CrCdT2Uf22joLnTkU4XV2n1rSrD
	WcMessYFspwrr4DQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776413614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TgbWk4XqXibZ4hp/e5YWk8D3E7kXbfcnOBDxRNOXiWw=;
	b=bsyX0P+4XR7qNF/IYxj8px/ezJcKUnujfKV44YCNx1JdLCnwQzP8Zo0UOz5HzoBZafKasg
	XRudMX/jh2nHdoEQLtw9+lhP+3fIuhNCNMFMV1Ciih79L9lnZ7ykpqai2PRUWjWes5QTRd
	MYHIOaqYN1KBgqhLOm4zbJKDQkJMovw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776413614;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TgbWk4XqXibZ4hp/e5YWk8D3E7kXbfcnOBDxRNOXiWw=;
	b=WxZpBaETIPfo3K5YBgEYZY2CoT4rnAg+FKWvjRp2vw1CrCdT2Uf22joLnTkU4XV2n1rSrD
	WcMessYFspwrr4DQ==
Date: Fri, 17 Apr 2026 10:13:34 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Liu <song@kernel.org>
cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
    jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, laoar.shao@gmail.com, kernel-team@meta.com
Subject: Re: [PATCH] samples/livepatch: Add BPF struct_ops integration
 sample
In-Reply-To: <20260416001628.2062468-1-song@kernel.org>
Message-ID: <alpine.LSU.2.21.2604171011570.24300@pobox.suse.cz>
References: <20260416001628.2062468-1-song@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2379-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,suse.com,redhat.com,gmail.com,meta.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:dkim,pobox.suse.cz:mid]
X-Rspamd-Queue-Id: 14FD2418859
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

On Wed, 15 Apr 2026, Song Liu wrote:

> Add a sample module that demonstrates how BPF struct_ops can work
> together with kernel livepatch. The module livepatches
> cmdline_proc_show() and delegates the output to a BPF struct_ops
> callback. When no BPF program is attached, a fallback message is
> shown; when a BPF struct_ops program is attached, it controls the
> /proc/cmdline output via the bpf_klp_seq_write kfunc.
> 
> This builds on the existing livepatch-sample.c pattern but shows how
> livepatch and BPF struct_ops can be combined to make livepatched
> behavior programmable from userspace.
> 
> The module is built when both CONFIG_SAMPLE_LIVEPATCH and
> CONFIG_BPF_JIT are enabled.
> 
> Signed-off-by: Song Liu <song@kernel.org>

Interesting. It does not make me comfortable to be honest. Is this 
something we want to advertise through samples?

Sashiko has comments... 
https://sashiko.dev/#/patchset/20260416001628.2062468-1-song%40kernel.org

Miroslav

