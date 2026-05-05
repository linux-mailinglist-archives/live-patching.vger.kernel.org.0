Return-Path: <live-patching+bounces-2711-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHE3JyrW+WlsEgMAu9opvQ
	(envelope-from <live-patching+bounces-2711-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:36:10 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 506304CCC09
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6933330636D7
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 11:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B306389114;
	Tue,  5 May 2026 11:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pkGBzGjt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="U4x87uSG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pkGBzGjt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="U4x87uSG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E02C30BB9B
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 11:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777980407; cv=none; b=P6zdH1GgrvfemtaZRBBpnhbtc8c3DIhZp4orvUWBMijpBpgR6yeaW79F6JXtflaZpJD6swM1L9BC1oeisTDWF4qvvCCsZ/WhPB0TIjmoapE+ChjSGJxGZv1FnfRGvqXi/xfbI0/RBRRffv8WN71NUUmKZWQT/Cx8awESDUUddEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777980407; c=relaxed/simple;
	bh=aVGS7FO5xK/c0oIkgsbzH6GCUVFZlRPiLIoKl/NTG9M=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=pgW5+3VB920hYhAOMPjFHpvr0FcEYWEo50rxmra7MOnjxN1vWc86+Ck9QV0asnxM5jQZijrZ7nW0ERh03ad5laLU8BDWzoz1MRngHSQa5o19dK/6mKivfjQ8D2J4/ybrEpCGeW0mBDhR3uqQvPOv4oNPHP4HrKRgfmYPfj+9Oaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pkGBzGjt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=U4x87uSG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pkGBzGjt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=U4x87uSG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id 9C5AD5CB59;
	Tue,  5 May 2026 11:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KuY01sAiRGGVNJ4is7mNlCtm1EwORP7dEVKFHGh1V30=;
	b=pkGBzGjt3RElB57G4TVVCJQA2eGJNU2LZcvrBHa4cRn/aBDy9N2HWte/yaeuqHIkr7DiT+
	73AQu7EoWWPII7NK7X7gxYxvP2r8tqCIWh/NQcqNy1Q4mBN759S+rbwF64uq8FnVCgfs8w
	7mEBYuxmOCHtJ29mhE9wQ2fEa1Y/Kfg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KuY01sAiRGGVNJ4is7mNlCtm1EwORP7dEVKFHGh1V30=;
	b=U4x87uSG5KPAF52y5Tbd4Z0EjRFm3DdVzgaA4NSE2vVu3KXp3bmf3FCyHfMDXJzhhnFQA6
	pxy11/kwgONlQ5AQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pkGBzGjt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=U4x87uSG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KuY01sAiRGGVNJ4is7mNlCtm1EwORP7dEVKFHGh1V30=;
	b=pkGBzGjt3RElB57G4TVVCJQA2eGJNU2LZcvrBHa4cRn/aBDy9N2HWte/yaeuqHIkr7DiT+
	73AQu7EoWWPII7NK7X7gxYxvP2r8tqCIWh/NQcqNy1Q4mBN759S+rbwF64uq8FnVCgfs8w
	7mEBYuxmOCHtJ29mhE9wQ2fEa1Y/Kfg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KuY01sAiRGGVNJ4is7mNlCtm1EwORP7dEVKFHGh1V30=;
	b=U4x87uSG5KPAF52y5Tbd4Z0EjRFm3DdVzgaA4NSE2vVu3KXp3bmf3FCyHfMDXJzhhnFQA6
	pxy11/kwgONlQ5AQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 32/53] klp-build: Remove redundant SRC and OBJ
 variables
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <63b0d7848597ad6011e1f56c8fdd53593d09a992.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <63b0d7848597ad6011e1f56c8fdd53593d09a992.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 13:26:30 +0200
Message-Id: <177798039058.9921.15977854439225629333.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=363; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=aVGS7FO5xK/c0oIkgsbzH6GCUVFZlRPiLIoKl/NTG9M=;
 b=owEBiQF2/pANAwAIAYF9a9xEqxssAcsmYgBp+dPs6JKPqMgw4QqLfrNJx96adpRjmzfsLe/NI
 Zsp5r3UfGSJAU8EAAEIADkWIQTrvUMeMZRtMCl77t2BfWvcRKsbLAUCafnT7BsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQgX1r3ESrGyz/lAf/Wa8o1BHZ3SHWsJAEgUMAtlYzpXAduYG
 I/3qwQhWbv/DWYL1mHA4zQUT47uuwR4PUn5zbI4zdTXTaKKbq2sWBCuTDXf3//EB40diWfMMyts
 9f3gJjHJ77f8avPeHHyZ+QmSsgxOKzH2GeexS81xjjXCxo8V7d2jsKxoaeU5JPnQ1wyyW9TFvkF
 4hEyivzT5jesueLHhgYBjXoVG8gKLM0gvFXrrs5q+GL2yeYXFnlm4/PA/pklMFT5AKDOlNYcNBB
 Rb3gqoawF6eB5fm5Pru6jG3weXxRGTnpuPpXRBC5S5ToWGqoT6ShrNA7Z5Fs8rqyk/p8enUAN5s
 xDdShQz8DzQ==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++
X-Spam-Score: 18.91
X-Spam-Level: ******************
X-Spam-Flag: YES
X-Rspamd-Queue-Id: 506304CCC09
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
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
	TAGGED_FROM(0.00)[bounces-2711-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.968];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:20 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> SRC and OBJ are both set to $(pwd) and are always identical.  The script
> already enforces that klp-build runs from the kernel root directory, and
> builds are done in-place, making these variables unnecessary.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


