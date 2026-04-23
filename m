Return-Path: <live-patching+bounces-2452-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0AHzK4ub6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2452-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:09:47 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8383C44CBCF
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:09:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B31A6304C431
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685B23D9031;
	Thu, 23 Apr 2026 04:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGJk09rc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D043D9021;
	Thu, 23 Apr 2026 04:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917076; cv=none; b=HXRrPp5OiCN5yavClUfM2XGDSLUkLZapeo/35nwvsVYbVcei/MMQ0EbPit+kNj4bD99XqgsiyLHEJFFpWMYJ1YxMVp+lypXhix93fVEreHaB9E9+zAORGPP+8Ax3vN0RGg4VWJoeziZ5T3MdQRvPsHwNUhpx3S+xBonz2pGNcaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917076; c=relaxed/simple;
	bh=WtJVJFghOUklJ4ji8GkVc/S/A2k9LHH39VLyaoUY8Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hChmC77/iiNntOGAX2Vl0MH+j6QWrBCdlXYYpoG7lTFSPCUGN2Btvc0E7InwyPaWnr+BLmoCpEcT41GKwqBtsFKirw8AwFl+wxMQy3MrERN0NO1upv6sqLyRS83Ekg5Sjw9lVgTm8TwVjl8ueVizP0YzqPdw8lhB5zqpJOu9rzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGJk09rc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E03C2BCB2;
	Thu, 23 Apr 2026 04:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917076;
	bh=WtJVJFghOUklJ4ji8GkVc/S/A2k9LHH39VLyaoUY8Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGJk09rcAD05iE6w4mhdyVB5+kWdNPHeXN08L8AjJf0H5NXLanIgRsUyPY0CzBHrh
	 ylKBorVSlDxYlw3aLy76vzlwc7wWT6ZtRrm4/1tGojxCXQ2S3n/nEVoIPzMtaQgMM9
	 PqDtKejgvpMpEpnZl3awlo9xifzR8yvfSgL+afsI67sorkb3Pc002GCuiwJrfTQhJ7
	 D8tST1m6BjiPI+Lry9Mwi/jTZz+wkDgUvVDPLuyhvfDfkFFjVRIFYm5MLqoCfyRglT
	 7Dvoa2JoXqmBxEYuIZQL4yWzwKBzcVBjGvuxTh/QRakCVyvudjbeze7ZHrmqDv3tH7
	 ZHAcLUP8cXvtw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 25/48] klp-build: Reject patches to realmode
Date: Wed, 22 Apr 2026 21:03:53 -0700
Message-ID: <f5ad8c1b51ba95187f0ed48f2f82056c8320337e.1776916871.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2452-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8383C44CBCF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Realmode code is compiled as a separate 16-bit binary and embedded into
the kernel image via rmpiggy.S.  It can't be livepatched.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index deb1723b70de..48abbe43f1c9 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -357,7 +357,7 @@ check_unsupported_patches() {
 
 		for file in "${files[@]}"; do
 			case "$file" in
-				lib/*|*/vdso/*|*.S)
+				lib/*|*/vdso/*|*/realmode/rm/*|*.S)
 					die "${patch}: unsupported patch to $file"
 					;;
 			esac
-- 
2.53.0


