Return-Path: <live-patching+bounces-541-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5AF3969276
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:01:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4928282D63
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713571CF2B4;
	Tue,  3 Sep 2024 04:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJdrH2b3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1CE1CF2AA;
	Tue,  3 Sep 2024 04:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336033; cv=none; b=BCUyawJWJefwVZxRPy6f03EehwbgNypGRlEoxmPpaRQrBJb7rJ6NQuzlQpK1Y4/DDhlpv2FLkWfFnQ0ziY16JvegSZQrTYI4AN4FMboCPrrGaQbW1i6Phi44md+b8MuBpxrcrHpnOockKKuoUR1M2pEILrYBFSSt/0ZyBKmE+QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336033; c=relaxed/simple;
	bh=8L3QglbaM3/yArmGhVUyyehtSdjxCRaSBZndVSMzeKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMJoVGzK4VgNYV8rgGoGx3oDmmdPymqmQHjc5LhtQCWjyRF+4NbX4RoC/lysnXOBm4Nh/gvMk3/c9rwlEn5xMjXh423/Wn1nlXtZtLY7LkRQUsSIQaCTyGNMNIq8S80kEfsIsSKMei1642oBpfC2mlWczPDkc6Zb1ogsbW/gIBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJdrH2b3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B82C4CECD;
	Tue,  3 Sep 2024 04:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336033;
	bh=8L3QglbaM3/yArmGhVUyyehtSdjxCRaSBZndVSMzeKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJdrH2b3yOgWrE1A1aZ7Y1g1nRHT00n3GbKJJdIbqzjKH55hSKvm7cUKuE/VosRE4
	 saZ+F67feTfx9qRoLwKc0p1mV0/b7VbdtZC5nvDd0AfzBuPqUq7hD8/1tuJesS6Z32
	 gr4stfCBJ/aWZOSgQk6JPv1rFhNhHo6bQCYetftaYGk1gNGNUEJh8wORlCkyDVjiVM
	 DVQdUaJGFmEeT4TLdzfdfoiNfD1zewxB0Rl3ikI8Bb6QZHQWblGpSwSacrNGlgIUkP
	 fZUSOhVb/iiI8AnmmwStBoOouDgAY9rX1sNwAiBhQGbAzBq/Gk2sXg9dqoYzlK1eFO
	 E77NAvDqijUzQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 08/31] objtool: Remove .parainstructions reference
Date: Mon,  2 Sep 2024 20:59:51 -0700
Message-ID: <121ee9edb1998fd7637f20b5c36b0c9d25e8bda3.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The section no longer exists since commit 60bc276b129e ("x86/paravirt:
Switch mixed paravirt/alternative calls to alternatives").

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 0a33d9195b7a..a813a6194c61 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4477,7 +4477,6 @@ static int validate_ibt(struct objtool_file *file)
 		    !strcmp(sec->name, ".altinstructions")		||
 		    !strcmp(sec->name, ".ibt_endbr_seal")		||
 		    !strcmp(sec->name, ".orc_unwind_ip")		||
-		    !strcmp(sec->name, ".parainstructions")		||
 		    !strcmp(sec->name, ".retpoline_sites")		||
 		    !strcmp(sec->name, ".smp_locks")			||
 		    !strcmp(sec->name, ".static_call_sites")		||
-- 
2.45.2


