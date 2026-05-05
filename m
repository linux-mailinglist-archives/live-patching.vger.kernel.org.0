Return-Path: <live-patching+bounces-2708-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Nz+OaK8+WmTCwMAu9opvQ
	(envelope-from <live-patching+bounces-2708-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 11:47:14 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BD0E4CA121
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 11:47:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EF0D7307DA1F
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 09:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C6A3321BF;
	Tue,  5 May 2026 09:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xLkuJQ57";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="P20A/Ot1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xLkuJQ57";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="P20A/Ot1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786EF326939
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 09:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974280; cv=none; b=LXq6h+5weLSNwM+Ob0Kv4W257/7cn7R2ZtRSsKYWbqcnrOP+C1EIgnmQ6zg/hDF73V2bbnr03txDc1ttS+b7r8ykTuZlVS2t0lhOlMM+imUmHS4lE1KPLtOu++aMwZbm6P0iVZbIWTKYnxs9EablrEgCfYv/9BOCsMk1nQa/Gnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974280; c=relaxed/simple;
	bh=+luKPtsPlBfNGNFS5SnU5+Wzc0xN8lPdgxImV7Y+pyg=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=SK9C0s+JHTHWEzojx1HsMihE80G7u6m88dK4qGRZn1rHGCzkWbmflBhzH/RRhQ+LL3ugtqPJbqEbTwbOVrJhK9b8CRk/hcVkfbKWXupUyrUYDglC5A1IFsdmHGrHIxLrevq/3xpdXgpikigSWKsnnzx0BQVwsbWcLukI04aZIDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xLkuJQ57; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=P20A/Ot1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xLkuJQ57; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=P20A/Ot1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id F1F815C65A;
	Tue,  5 May 2026 09:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777974260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZ07x5knHt7sd/+zwzYE/XMDkPGbiAShsGR58sVEOAM=;
	b=xLkuJQ57UMDtwrHIEOJ9kEdRzHLVG6jjyWhUDwiHYxYtpLqSppNv0IFBHxL9HRdw36z2UO
	um5ue1ya6yNTHpu5Fu8nj/djvthKKEuttFa0ZNWOy3A3aH73qhcX7qI1Y/FdgvqZoFJd80
	QuLrvuJNCwHMIzTtUyRZVNDgtJaF6vc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777974260;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZ07x5knHt7sd/+zwzYE/XMDkPGbiAShsGR58sVEOAM=;
	b=P20A/Ot1QBwWldKgQNQ/1tHxYj3HmrvR0MB7Y8nRhQwoF7jR8R1guv1w8La1hNGXX0c+fG
	LZ1X2dOs1HCPMjBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xLkuJQ57;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="P20A/Ot1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777974260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZ07x5knHt7sd/+zwzYE/XMDkPGbiAShsGR58sVEOAM=;
	b=xLkuJQ57UMDtwrHIEOJ9kEdRzHLVG6jjyWhUDwiHYxYtpLqSppNv0IFBHxL9HRdw36z2UO
	um5ue1ya6yNTHpu5Fu8nj/djvthKKEuttFa0ZNWOy3A3aH73qhcX7qI1Y/FdgvqZoFJd80
	QuLrvuJNCwHMIzTtUyRZVNDgtJaF6vc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777974260;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZ07x5knHt7sd/+zwzYE/XMDkPGbiAShsGR58sVEOAM=;
	b=P20A/Ot1QBwWldKgQNQ/1tHxYj3HmrvR0MB7Y8nRhQwoF7jR8R1guv1w8La1hNGXX0c+fG
	LZ1X2dOs1HCPMjBQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 23/53] klp-build: Fix hang on out-of-date .config
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <5e2a75b8ce5120bbbec6c8e992f1d3c772b8e5d5.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <5e2a75b8ce5120bbbec6c8e992f1d3c772b8e5d5.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 11:44:14 +0200
Message-Id: <177797425478.9921.16895890017621143422.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=323; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=+luKPtsPlBfNGNFS5SnU5+Wzc0xN8lPdgxImV7Y+pyg=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyfuz9u/tpi7pw27YhOr1fhfuXEt8uP6DesiW5/3i6T6
 OqgJLipk9GfhYGRg8FSTJHl9V5nOcMpuQaa1e/uwgxiZQKZIi3SwAAELAx8uYl5pUY6Rnqm2oZ6
 hkCGjhEDF6cATHX9ffb/ZQLTTS/uSr6p7hIXN/Vyo2VH+syrqm3VV0M+etzdbv8hemXzpfz5x7X
 537ry7Yo0fGmntkqBeXeRq2Ff18Er5zZsFL6tcKY883wER8VC18k6r/dzN25esPr9z/shN2/cOs
 uyVk/ozgOL1pefFoUX5FqH7FcoOvHKpnn7Hedt6jdFru+Y+fjcLR/7X7t4/c7wtKkk9zM5PCvf9
 zHEp4v7iO23/H6fdY3Ki19W3WOrkoye+EbaZML7S7+2C24ujZ7Gkjqjh7n+CZfJsq5+rQzbC71v
 H0/Z7/Rq95cpoXfOnHq741ldHqdGz/PfFxVjtDb+mOjv+NnpotJly/+uZpqP5yWHzm6ftjPFasu
 uj2w/jQA=
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 17.86
X-Spam-Level: *****************
X-Rspamd-Queue-Id: 4BD0E4CA121
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2708-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.967];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Thu, 30 Apr 2026 21:08:11 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> If .config is out of date with the kernel source, 'make syncconfig'
> hangs while waiting for user input on new config options.  Detect the
> mismatch and return an error.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


