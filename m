Return-Path: <live-patching+bounces-2718-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AL7fG8bW+WmVEgMAu9opvQ
	(envelope-from <live-patching+bounces-2718-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:38:46 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4574CCCC0
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A50A230CF7FD
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 11:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89595390CBD;
	Tue,  5 May 2026 11:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aKTGLiA+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WOwB9Qhl";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aKTGLiA+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WOwB9Qhl"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436E82773C3
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 11:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777980740; cv=none; b=pPnT3k7Qw4jeIqd9VLqOz4RkBO1PKFaUf/wq6SBwKIEG1w+6nocRZSYUJWcbCI1CARK22/EzcjXnqCr7+FPIJwmYn5l4Tgo7mI33lNyRYq7SKO1nexAS58TP+E1ZOv+v9KStVO7LWZSegKSL4JaBgHrU3CkVFYkVFBi0YlgZL+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777980740; c=relaxed/simple;
	bh=ekr4/7qxE02ivTDjI1BcFpOBbiuo4ojvY/Vxv8NnM2k=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=dLuCjrKKZh+AD6qj7qs7CfEAKX7ATYlydiu98pnqM/FWagcKHFLk8xD6Y5Ca8NElov8u534mVxYkoPVDLbAYbze7wV69YYKQK4lRGCJdS4fqCGncs5+9dHr+wck7GHcJcxh9n2aN89hQmrs14eIbRmhWOGhHjGbCyB9c0a6VHew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aKTGLiA+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WOwB9Qhl; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aKTGLiA+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WOwB9Qhl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id AF78A5C178;
	Tue,  5 May 2026 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1kdVGW1rcuFzsF08TcX0Kt74y+XfMVrEWDS3g8z/tDM=;
	b=aKTGLiA+XmxqDaYeokalcOIQdDOjCG0Vnl47pAMsFR1yixOFjKsDY0NeUO7ozxtrsfz/Gj
	pE0HKI2ixNDMtLuwzna2DweCpWgN/o/fkYGSRMy3rP+ZTe5IcXBzbJqZweb68JiMJh4C4Q
	8ZrhKto/ns7UPqurlDCw4sk5lN7QVIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1kdVGW1rcuFzsF08TcX0Kt74y+XfMVrEWDS3g8z/tDM=;
	b=WOwB9Qhl0bbAxJzqUdvydcVpiIC0EOKCxMTerXTEN9PncUF67EW10TXWIE96bcMNmfgWFA
	tEUE+UPE0GQLo3CA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aKTGLiA+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WOwB9Qhl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1kdVGW1rcuFzsF08TcX0Kt74y+XfMVrEWDS3g8z/tDM=;
	b=aKTGLiA+XmxqDaYeokalcOIQdDOjCG0Vnl47pAMsFR1yixOFjKsDY0NeUO7ozxtrsfz/Gj
	pE0HKI2ixNDMtLuwzna2DweCpWgN/o/fkYGSRMy3rP+ZTe5IcXBzbJqZweb68JiMJh4C4Q
	8ZrhKto/ns7UPqurlDCw4sk5lN7QVIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1kdVGW1rcuFzsF08TcX0Kt74y+XfMVrEWDS3g8z/tDM=;
	b=WOwB9Qhl0bbAxJzqUdvydcVpiIC0EOKCxMTerXTEN9PncUF67EW10TXWIE96bcMNmfgWFA
	tEUE+UPE0GQLo3CA==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 33/53] objtool/klp: Don't set sym->file for section
 symbols
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <d44d6a8f8256c9d3896bf531050c969cb15f2661.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <d44d6a8f8256c9d3896bf531050c969cb15f2661.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 13:31:45 +0200
Message-Id: <177798070550.9921.4584032162765722037.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=318; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=ekr4/7qxE02ivTDjI1BcFpOBbiuo4ojvY/Vxv8NnM2k=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyfV5VPyl9cHjf7d/k2+WfCH09Nir7C0deeN3HpKmHLy
 6uaWaL3dzL6szAwcjBYiimyvN7rLGc4JddAs/rdXZhBrEwgU6RFGhiAgIWBLzcxr9RIx0jPVNtQ
 zxDI0DFi4OIUgKm2CWX/p+P/od3vqTubV7eA8fSlp469KGzmOWlfNnldTdLDo3npcq3lQYce1yp
 /D9UrbLjh1t5Ro/+rafdr3r2tJbNv3S1r9bWotuH2e/f0ub51hfXG1MCa9M7CM4WqWosqD102Zn
 ggmXLmz4TF58/N4Ssw82E4NeW92pfwRZyPeSZ7Pe4W+yfB/W+bgPw2YWtBdS1VW+bOb39rZiTfL
 YpddOhUp+TLF2n7tp67+stjqqznfJY49SP7pjpPipc+G9/6Zr/jgbcRHwWf2Jj80Hq6iC/9p4vf
 r+T1HfIXIyP+zWCzc/7SyFCy7fU6xj5N3ndZ93Y6LbG5auYjkyZpGJPo9KCpyNZu/ek+9jvC2mp
 r+QIA
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 18.48
X-Spam-Level: ******************
X-Rspamd-Queue-Id: DD4574CCCC0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2718-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.969];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:21 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Section symbols aren't grouped after their corresponding FILE symbols.
> Their sym->file should really be NULL rather than whatever random FILE
> happened to be last.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


