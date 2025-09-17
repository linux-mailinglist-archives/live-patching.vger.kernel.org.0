Return-Path: <live-patching+bounces-1703-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0052BB80E24
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:12:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30FE91C25F78
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48DD3728B7;
	Wed, 17 Sep 2025 16:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bkP1UJd2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D04337289B;
	Wed, 17 Sep 2025 16:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125090; cv=none; b=t8BKd+1JrAy7TpOsXgWeKbtpHXF1WNa8AeB0fHAcVKwkaTbOTtrUC+s/LvMXEiy7H8pjSdJe4VH9YoRvm5sdm4WIhTO3onfq/W2a1rBvP4jrr92YLTJhnVsgmuMM6pA+/wtIxyHMKRqfvox51+aEQbqWSi8a+rV6rRKYBRnT/mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125090; c=relaxed/simple;
	bh=dnt/z9hARvStKWljmL+I3QaEvBah+tUNPCjBSil/26g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWiCmvJ3Ie9bZh6QDe0WgRHwMBDgyEEC0Ge83OXO6BwcKvLw5VijVPOxOR6fkMyfpp5xh5oYLsf0qs5Xv0LKa/IN3M3pzfWC8FQYAq9tB/CXxQHvwi9Tp4kqn4WYmcwmaFZQh7p4Ar1kHAoPJ1KW1LSG8jsTwUoWdkyWcEvrqPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bkP1UJd2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE327C4CEFD;
	Wed, 17 Sep 2025 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125090;
	bh=dnt/z9hARvStKWljmL+I3QaEvBah+tUNPCjBSil/26g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkP1UJd2dPvX+lDMm/CqjmltITpUqK1Rp30EvX0Uz67P+I2As2yv3xM49UkAdRm2w
	 DD5xib9fFH6Ii1vYn0x0JQAnfuESNaHzNs/mNmx7EZaFu/+Dwrfy4hICQ17cZPLEjg
	 +DN3iq15e7VHrDC7DJe3nzMPe+HDtMxXqKYVaNm4iWTTSGNCp10Cst8/2cVKCYvcmh
	 DbIAv6FYtyJZ6tmoFNU2EuF/nD689Hv2SXpnz0n4LXVisVEGux+VjKx6B1L0kwGmfZ
	 2ipJZDXN8M4OcULsM8S7YT8wS1k4Bxjyv68y23LhcSH+Tx9rMSTkGTKtf0lJuVBvCS
	 eZuyM8VDqinCA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 48/63] objtool: Unify STACK_FRAME_NON_STANDARD entry sizes
Date: Wed, 17 Sep 2025 09:03:56 -0700
Message-ID: <ac05633d7accc0347412d1b9fe08327b31d21e73.1758067943.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The C implementation of STACK_FRAME_NON_STANDARD emits 8-byte entries,
whereas the asm version's entries are only 4 bytes.

Make them consistent by converting the asm version to 8-byte entries.

This is much easier than converting the C version to 4-bytes, which
would require awkwardly putting inline asm in a dummy function in order
to pass the 'func' pointer to the asm.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/objtool.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 4fea6a042b28f..b18ab53561c99 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -92,7 +92,7 @@
 
 .macro STACK_FRAME_NON_STANDARD func:req
 	.pushsection .discard.func_stack_frame_non_standard, "aw"
-	.long \func - .
+	.quad \func
 	.popsection
 .endm
 
-- 
2.50.0


