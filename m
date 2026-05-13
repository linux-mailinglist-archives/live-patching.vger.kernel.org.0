Return-Path: <live-patching+bounces-2781-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gFDBCcDyA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2781-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:40:48 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D026552CDC4
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:40:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2907330AC73C
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C2E3AA4FA;
	Wed, 13 May 2026 03:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8hdIHrT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6D43AA4E0;
	Wed, 13 May 2026 03:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643290; cv=none; b=lk2JJkOtew9RfcI0A0AajVCT9z7GenclvYp8OTZ275qTpVzBVGefSoL+2j7kF+J8cotZAVIN4d1FuPE6rMXuOXheRjMeNW/9crBy9PcH5tUEcBzJ8zjpCSSbU68jT1rqXvDontLDWroLPv9u+GrMIuW0m1fv2qMB2FJ/H/r1OXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643290; c=relaxed/simple;
	bh=n0zIE5QeG6gMOvBsdlMrDubUOuT5GRIBXLzLQUDUXac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITwumW8/YvqzM4aw/ao/4alWSBGaVMQwPGhVrTBQS8Ydf+n8ku3Q2MWkS5qKsY+dASfAFMOZnnCPioJLxy7uaNqVXkTE/7mvoauYPw/LPJv+MVFGPQRRoTdNUGqjJC3nAF8qlSY4OfhwaYMJYIES9t59gcyWX8RSWx6tR5oSaGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a8hdIHrT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA04C2BCC7;
	Wed, 13 May 2026 03:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643287;
	bh=n0zIE5QeG6gMOvBsdlMrDubUOuT5GRIBXLzLQUDUXac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8hdIHrTWDu0YaYDs2Z5CBvbdW+bWitNDdUfJ5nc9Xn1AQUgx3LQYnPbXwkcy6nLl
	 LVBcQM+HUK0uXO1vPwUyZpqwVo6IkIxTL0RvLRNtnV0I00nCR4gNAa5IUz/LDAgzxW
	 RTbdfAASG6K5VPvxaD1pL/RZuuUPwOSMSchZ2XSO/ajEbnpWh0Z8MU2ZZA6AbU5w4/
	 owoc7kBxF/YjZW4CNNRJ5Vm6JzJFe1B8WbRA8DXdz2ae40gFW5FK9WFSSKlZYybJw/
	 q8wgBbkT3kr+ncYmriogNmaitJkZoMwjCvXCuuiqP2DqgYVldLvBBkE8Z8Tdq/6Ti0
	 sqiXm5yyb0Umw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 05/21] arm64: vdso: Discard .discard.* sections
Date: Tue, 12 May 2026 20:34:01 -0700
Message-ID: <bff1bad8bbc43ddf123e91b844073229eeb56b56.1778642120.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778642120.git.jpoimboe@kernel.org>
References: <cover.1778642120.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D026552CDC4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2781-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

In preparation for enabling objtool on arm64, add .discard.* to the
vDSO's /DISCARD/ section so objtool annotations don't cause orphan
section warnings or leak into the final vDSO binary.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/arm64/kernel/vdso/vdso.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/vdso/vdso.lds.S b/arch/arm64/kernel/vdso/vdso.lds.S
index 52314be291912..d5f96fa17e605 100644
--- a/arch/arm64/kernel/vdso/vdso.lds.S
+++ b/arch/arm64/kernel/vdso/vdso.lds.S
@@ -39,6 +39,7 @@ SECTIONS
 	/DISCARD/	: {
 		*(.note.GNU-stack .note.gnu.property)
 		*(.ARM.attributes)
+		*(.discard.*)
 	}
 	.note		: { *(.note.*) }		:text	:note
 
-- 
2.53.0


