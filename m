Return-Path: <live-patching+bounces-2720-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cGyrMX/V+WlsEgMAu9opvQ
	(envelope-from <live-patching+bounces-2720-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:33:19 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B304CCB55
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:33:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 30842301DE63
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 11:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D1E3921E9;
	Tue,  5 May 2026 11:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FbZPgoPB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qNgBA/E1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FbZPgoPB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qNgBA/E1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0141D388E49
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 11:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777980752; cv=none; b=U5iL0S4Bj6yqZeq34S3f0EUArb/ZVyp12ji321HkKrI3ZyXNmPylZf/ehPa0bRUT/AZ16SF29RTTtEbKOnt8/nNh/j47wX6lktdp9BaOh3HFDMPvDHQwVdRwCsDIk08+oDFXVTuINnNBGiCrKcnM5XV6ULME1qQ1g0dy74ei6J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777980752; c=relaxed/simple;
	bh=qP3HWm+Xq0gkUJQ6k4XmFoVQTF6IXo3vFlhHV8an+2w=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=BbT9pp4FRtjrVIwGZwcHlBXthOHe0TFmYtUuXO6HDhllcomT2xOv18hEdQ4bCnhBmBGzxJ8vK/0j8Jhd0kjGKY1jpVDlqIosn5Fd12bogWyTb3uTkr9eRjIqp+HhU/9JxFKJyUOPfCFfcP6SacdkIYKQGIFYuxDiymOVBL1Bbr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FbZPgoPB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qNgBA/E1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FbZPgoPB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qNgBA/E1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id F3E0B5C231;
	Tue,  5 May 2026 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p8w/rhCmCvwbIIneUPs/oUwccrVc4100AzePzdTlbfc=;
	b=FbZPgoPBSOpL5yD8+IR2oKJc2Yl69Al2je3RTcjoX3zbTBKvDaKPZnfuGT081Q9u1sDkuL
	QiKyJ4g2QPDCjlik36IcTx/26ATb1F/g5Dts+SY7SJ+mGYxDv3pRjDgiW37NC5kmlCFCce
	LhJdkAdUgS+WrnNmbQxHHkxReb97I0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p8w/rhCmCvwbIIneUPs/oUwccrVc4100AzePzdTlbfc=;
	b=qNgBA/E1mmbMEvdHyQ2BLkZuwtFiovzv7DUbJl/ISmrlRf3LJaoBk58J+RoDZnnSIgN4Fj
	oLrOAG01ZgsWE9AQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FbZPgoPB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="qNgBA/E1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p8w/rhCmCvwbIIneUPs/oUwccrVc4100AzePzdTlbfc=;
	b=FbZPgoPBSOpL5yD8+IR2oKJc2Yl69Al2je3RTcjoX3zbTBKvDaKPZnfuGT081Q9u1sDkuL
	QiKyJ4g2QPDCjlik36IcTx/26ATb1F/g5Dts+SY7SJ+mGYxDv3pRjDgiW37NC5kmlCFCce
	LhJdkAdUgS+WrnNmbQxHHkxReb97I0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p8w/rhCmCvwbIIneUPs/oUwccrVc4100AzePzdTlbfc=;
	b=qNgBA/E1mmbMEvdHyQ2BLkZuwtFiovzv7DUbJl/ISmrlRf3LJaoBk58J+RoDZnnSIgN4Fj
	oLrOAG01ZgsWE9AQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 35/53] objtool/klp: Create empty checksum sections
 for function-less object files
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <94267cbd67da8e158153743b80f4d2bfb3f62b4a.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <94267cbd67da8e158153743b80f4d2bfb3f62b4a.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 13:31:45 +0200
Message-Id: <177798070551.9921.11609701398522102213.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=541; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=qP3HWm+Xq0gkUJQ6k4XmFoVQTF6IXo3vFlhHV8an+2w=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyfV1UyW96FrlO+dcN+zdl5G6+vn6uocnD9xjwVWX+mC
 Wz5VRvLOhn9WRgYORgsxRRZXu91ljOckmugWf3uLswgViaQKdIiDQxAwMLAl5uYV2qkY6Rnqm2o
 Zwhk6BgxcHEKwFT/l2b/xfx9dmZojktf9o+X/3cmcMeanPNVuDa1gMVFKmtiWfTflCKGRxum/3q
 bduL7jNbt9b9Z48+E5DNbde89f+9BssHLRX4L+Bi0pBar/byQ7ZpcO/+n4Wu/4NQAHvsjT0/+/2
 fZfavT+uwBo60zk/lK1W8+nq8dve7MoW2lof2KwRUfYo/Ebp6//+aR1SaySov8c/4KFfbtl9l+f
 sbjXxvmL3zbH9GSLpucwrSCMbLvmlyTwyqp/C9FmnaWq1XDOM1PpIS2q078/TX0XhJDz+SWG5PF
 jI7O1X63Ve6uII+pweZcXS4l9WcR1mF5zJU3JXavWfvykmtB8NHXlQpJia0LtlufcWayf9N297D
 gLdnfAA==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 19.47
X-Spam-Level: *******************
X-Rspamd-Queue-Id: 93B304CCB55
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2720-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.967];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:23 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> If an object file has no functions, objtool has nothing to checksum, so
> it doesn't create the .discard.sym_checksum symbol.
> 
> Then when 'objtool klp diff' reads symbol checksums, it errors out due
> to the missing .discard.sym_checksum section.
> 
> Instead, just create an empty checksum section to signal to
> read_sym_checksums() that the file has been processed.
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


