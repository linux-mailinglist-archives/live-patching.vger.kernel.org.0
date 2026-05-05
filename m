Return-Path: <live-patching+bounces-2719-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qG3lGM7W+WmDEgMAu9opvQ
	(envelope-from <live-patching+bounces-2719-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:38:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D257F4CCCC8
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6125E30D2D14
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 11:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DE639182A;
	Tue,  5 May 2026 11:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jDelvoFP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3kPuD4G1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jDelvoFP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3kPuD4G1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28882874F5
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 11:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777980746; cv=none; b=tJq7kFL2oH2yDZqTBgnyg3/D/3tFqeya8vduAJh41CumfP1FtljEZdauFQ00suhKnuaPQgcwSlTDF+zoDog7CsEuz0Di0J3wgEIDDbahdB1/s6mL0F89k0RMtl1HTP0Heq7GWNFYukXfM77VPgFIcquo6NmfG5Q2Bp3QlGvSmlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777980746; c=relaxed/simple;
	bh=/KUtDl2WimIUmpHLo3fVA6dT57eXa4Dc/gAQtSDfbZk=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=a135G24Q0EKLsDsQX6rjQdXSEtr51iqk00emGQQWb8QZ8Mo7JfoOsIpajSHjIOlF+QD0HJJd0PC5g319Gn5UfWZ0bPItUlPPFn6jdX/QFy2KqseNPzN4uE+JpMUTnO+u24XxZibyAA97EHgOoZSBGYRVrR8IoyHzBtEss2pPlgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jDelvoFP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3kPuD4G1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jDelvoFP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3kPuD4G1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id D39EB5C213;
	Tue,  5 May 2026 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQVecrh+7FRfBbTuc/2Zr1IYzKa4yER5B5TMNSQ1954=;
	b=jDelvoFPy0WisO7A2HPI2kvEBZTySt9AwMa7h2L39vXiQ4R1SmTkdIkUYfM8sxeAQSYCAv
	Klr5fkIo33aD3zoYdsW9s3DXHEUwF1Yb60KexN4lmsVipPM/tnGRSpTB3Vp0r5xPPeQ0TH
	wfiBw2P8BGWHM7ya7GAEvGbdzmHNmH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQVecrh+7FRfBbTuc/2Zr1IYzKa4yER5B5TMNSQ1954=;
	b=3kPuD4G1sfyc3vurv79Nb/AJ3889AlSYDgt+GFprJZFyfW6OvaIxzTKzwP+kd/4cihwY/0
	Xw93mGRw91FKSsBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jDelvoFP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3kPuD4G1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQVecrh+7FRfBbTuc/2Zr1IYzKa4yER5B5TMNSQ1954=;
	b=jDelvoFPy0WisO7A2HPI2kvEBZTySt9AwMa7h2L39vXiQ4R1SmTkdIkUYfM8sxeAQSYCAv
	Klr5fkIo33aD3zoYdsW9s3DXHEUwF1Yb60KexN4lmsVipPM/tnGRSpTB3Vp0r5xPPeQ0TH
	wfiBw2P8BGWHM7ya7GAEvGbdzmHNmH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQVecrh+7FRfBbTuc/2Zr1IYzKa4yER5B5TMNSQ1954=;
	b=3kPuD4G1sfyc3vurv79Nb/AJ3889AlSYDgt+GFprJZFyfW6OvaIxzTKzwP+kd/4cihwY/0
	Xw93mGRw91FKSsBA==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 34/53] objtool: Include libsubcmd headers directly
 from source tree
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <9582e7b77cb498a490bab6b93c1b330525f1a5c8.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <9582e7b77cb498a490bab6b93c1b330525f1a5c8.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 13:31:45 +0200
Message-Id: <177798070550.9921.2250097801240504461.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=385; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=/KUtDl2WimIUmpHLo3fVA6dT57eXa4Dc/gAQtSDfbZk=;
 b=owEBiQF2/pANAwAIAYF9a9xEqxssAcsmYgBp+dUknwDpKK4vGb2JR/8rwNovuXCJEVG+IXDsB
 yzojKjtiF6JAU8EAAEIADkWIQTrvUMeMZRtMCl77t2BfWvcRKsbLAUCafnVJBsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQgX1r3ESrGyzKvAf/TAQn+QYlDr4E0FYrh6EVSeCZzybI8Vi
 YtZce7xX9l1freInekeuafuje5mgNyWClemyFXh9kih3A5s/x7qR8Eh/FoVf5Kglx1tlKLZiGSf
 H+g7t/5qtX4pxNUUd/A6ty3TbXUqQNv1OgpRyEAG/NyH6beX5eDsjDq3KQF3KOpHGFkyiterxYW
 F2L2hLrooR2yvx3NQWpyHBAtEU0PTrMoTgoDEbP9N8YGW/YyjBR2t2LQt2rDcwPj9omoDqDKbv8
 POiH7LP5eW++t0vhyCAr0EuWPAec6/wWnr01APHNwu9N+TOW346++fRDhqDF2P6xErnVjHzHzHf
 tDu4iUCbEsw==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++++
X-Spam-Score: 19.21
X-Spam-Level: *******************
X-Spam-Flag: YES
X-Rspamd-Queue-Id: D257F4CCCC8
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
	TAGGED_FROM(0.00)[bounces-2719-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.967];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:22 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Instead of installing libsubcmd headers to a build output directory and
> including from there, include directly from tools/lib/ where they
> already exist.  This fixes clangd indexing which otherwise can't find
> libsubcmd headers.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


