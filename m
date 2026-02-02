Return-Path: <live-patching+bounces-1964-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UERGJW8FgWkCDwMAu9opvQ
	(envelope-from <live-patching+bounces-1964-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 21:13:35 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F01D9D0FAC
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 21:13:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E2B833032F5E
	for <lists+live-patching@lfdr.de>; Mon,  2 Feb 2026 20:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462E630EF6B;
	Mon,  2 Feb 2026 20:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="F7DMfHa7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="R335l92P"
X-Original-To: live-patching@vger.kernel.org
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24933033C7;
	Mon,  2 Feb 2026 20:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770063073; cv=none; b=Cz/4pgxoAUJRsm/3UP+ZTgvNPzF0t1jHYmXrYZkjRTHUD4+EX9CvMZ9c40+OwNCVswinjUMF1WLDM5WV/k8pyJYnVOlSka3xuVGSHRauBEZnNMcPc951awklcvVoUYsVjnqnULXpVZLareb10HAAtqxfctQ+4X7fLPGahaiC934=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770063073; c=relaxed/simple;
	bh=If8LANTbRmcxjzVuMviXEpyIVIxptSlaPLEHRdefM+c=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=UMro10XzNp3PQwUeyzw8hC+94yPxURhwmjgfleNIgX6yTmh3tD76t9nSo9O4HNK/wzvgR8JrEFjZMHPsFE7tt58eGREtogka9JB6UX8LJ+mdJJ+56bRQDlwUEL28Ip8Z+jO2sCDmZZv1YqUD4wc8shh4HMq04TVMdjDkZ/IkJr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=F7DMfHa7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=R335l92P; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 04064EC0012;
	Mon,  2 Feb 2026 15:11:11 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 02 Feb 2026 15:11:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770063070;
	 x=1770149470; bh=wfXzIveNRcXVOxhS7YSwmTs6f76XRgD8ZXa05mrCfFY=; b=
	F7DMfHa7qODzlcPNaN/lPAn0T4m4uLzlZblcTuP/MsBi7sS/knsBAph8EPicimA6
	WxP8sirwp+8M/nk09c1Gj/dWqUiCCAgMKLtHt5PyPLPlR3O2nHT/S/4CJoioOmam
	d23hrqBA2F50p7n659ntdwvcxN4tkM+4qWjvfbI3Ft4DcGD+iggIxhK0WD8JZFpL
	NDWaWQRykDK43GARlbfk0jaxelYhhaStm/gW1MKYnQeDdaHZfqiQKb1nu2iq/u2F
	dkxso5Z3gC4kKUWcFx2P/7+hsra9k2RlZKDYlyRniO2Kvt1oKJdQPviiJcWzZAla
	vljvDVEI5hLnuWbrFY6ESQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770063070; x=
	1770149470; bh=wfXzIveNRcXVOxhS7YSwmTs6f76XRgD8ZXa05mrCfFY=; b=R
	335l92PgPqMPE1I3IiqCDARFquVuQfMgq9uI+CBEYx8U7O4CmnVpJ/iCf4Mro0N/
	ZjW/YiQLbpgA/emPNU0IUN64IG/SP4VtGEPTglfvlhZRN6wH2OuwLWUL79vRm5/I
	KkE88v0QtjfM/3Ao1cNvlUNpi62x7Ahshx+V79xZm0kWwoUSWGYMnCN+xq1PFqve
	FZa6Q4U8IKoAQJBisFNJbPJ+V6xOZba3h2nxQDLu8IqUdrJo/YxxBCXWsJ+H9+wA
	wyAvaPlA135z3mQo3YvtU44UmtHUzRGJXhErgzomNrHURkb2zBpG9PLc0gp4rExx
	ofT3zGWCFxsnSatIcDcpQ==
X-ME-Sender: <xms:3gSBaRx1dfsFIHQIJ_bCwNez47eW13BZyuT5bveV5dTxhNXoQC9Qrw>
    <xme:3gSBacHYmLFCAELMXCVty_M_FJaQdfdXAanAomS0z3Xt5eRPNAeSsboHGRgo3_kV_
    IuhR6uqA09v53ji8eaHnHaCUz_YqpRZWjWZ4whEFhzdheU51sjW95U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeekheejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohephedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepphgvthgvrhiisehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoh
    epjhhpohhimhgsohgvsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehlihhvvgdqphgrthgthhhinhhgsehvghgvrhdr
    khgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:3gSBaU8qpV6Z1sfpx42qg3hv4ExORb4JzpKCxh03sYZxYhQeijjPdQ>
    <xmx:3gSBaVpXJjdc8_mi87HyXmA_qcRvADzn9oEfiPX3EdfGONkjuttQIA>
    <xmx:3gSBaVlV_9YxGnIjuK_63-ptyMDpm5tV1Xz-QTki6VyPFNXLIIyr4g>
    <xmx:3gSBaUiO4sTo3KpTJwdAYTnXPdXlI51q2cky5FXWLyMe3_x9t8zuoA>
    <xmx:3gSBacBUw--IqPXE8yDPPcTam_XFv67WKTrhS4q_8D2sP4DrRBU-b5cO>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C74DB700065; Mon,  2 Feb 2026 15:11:10 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AmVGb13jyKd-
Date: Mon, 02 Feb 2026 21:10:49 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Josh Poimboeuf" <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 "Peter Zijlstra" <peterz@infradead.org>
Message-Id: <c8ed9222-8072-43d4-897e-3fea24910e3d@app.fastmail.com>
In-Reply-To: 
 <0bd3ae9a53c3d743417fe842b740a7720e2bcd1c.1770058775.git.jpoimboe@kernel.org>
References: 
 <0bd3ae9a53c3d743417fe842b740a7720e2bcd1c.1770058775.git.jpoimboe@kernel.org>
Subject: Re: [PATCH] objtool/klp: Fix unexported static call key access for manually
 built livepatch modules
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.15 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[arndb.de,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arndb.de:s=fm2,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-1964-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[arnd@arndb.de,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[arndb.de:+,messagingengine.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arndb.de:email,arndb.de:dkim,messagingengine.com:dkim,app.fastmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F01D9D0FAC
X-Rspamd-Action: no action

On Mon, Feb 2, 2026, at 20:00, Josh Poimboeuf wrote:
> Enabling CONFIG_MEM_ALLOC_PROFILING_DEBUG with CONFIG_SAMPLE_LIVEPATCH
> results in the following error:
>
>   samples/livepatch/livepatch-shadow-fix1.o: error: objtool: 
> static_call: can't find static_call_key symbol: __SCK__WARN_trap
>
> This is caused an extra file->klp sanity check which was added by commit
> 164c9201e1da ("objtool: Add base objtool support for livepatch
> modules").  That check was intended to ensure that livepatch modules
> built with klp-build always have full access to their static call keys.
>
> However, it failed to account for the fact that manually built livepatch
> modules (i.e., not built with klp-build) might need access to unexported
> static call keys, for which read-only access is typically allowed for
> modules.
>
> While the livepatch-shadow-fix1 module doesn't explicitly use any static
> calls, it does have a memory allocation, which can cause
> CONFIG_MEM_ALLOC_PROFILING_DEBUG to insert a WARN() call.  And WARN() is
> now an unexported static call as of commit 860238af7a33 ("x86_64/bug:
> Inline the UD1").
>
> Fix it by removing the overzealous file->klp check, restoring the
> original behavior for manually built livepatch modules.
>
> Fixes: 164c9201e1da ("objtool: Add base objtool support for livepatch modules")
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Tested-by: Arnd Bergmann <arnd@arndb.de>

Thanks a lot for the fix!

     Arnd

