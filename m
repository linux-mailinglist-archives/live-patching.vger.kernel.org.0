Return-Path: <live-patching+bounces-2137-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yEopN5kOqmngKQEAu9opvQ
	(envelope-from <live-patching+bounces-2137-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:15:37 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A11D21934F
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:15:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E06FB301F1B6
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 23:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5EA33BBD7;
	Thu,  5 Mar 2026 23:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u22IA2oc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599F0283FC3
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 23:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772752535; cv=none; b=PmUtvMbsgx/qekjDpTTZnYGigeHuWgZVoVmcc99AWz4T+9mHnKQiTLcGVpS/zB7lBNuhmkjd440C6lKmDlotCZWTGHrsxlyIf9XhbL2eCqFHHh4sjMbXHEBhj0do1YW3IqcV4K5y7lFD6nwFqAB58Py4/T3KJl639j/uq2A7MuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772752535; c=relaxed/simple;
	bh=4rjT1rwOqXjaQJfd4t4PhmPTcbbckNiz/v+thPhrSEc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bHWfZyfnafP3bqI/dMp8kBEtWUsXtvBWoqEX1tbZkXfIk5Yp2h9hyBUlpyiT4DOUhCyalpWQdnO0glAvq/UfSQkFeZuBZS59lD/dxjbAgowaz6xFi4UevwWOozWsrEO390rN3SvWAqD1PUqUrqwLB8WcX+9piiOWOwdd+apdStk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u22IA2oc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F0FC116C6;
	Thu,  5 Mar 2026 23:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772752535;
	bh=4rjT1rwOqXjaQJfd4t4PhmPTcbbckNiz/v+thPhrSEc=;
	h=From:To:Cc:Subject:Date:From;
	b=u22IA2ocSYQk38IpjYPypnpdwXS3+HuNDSgkggPw7zaRtaHI4m+hrK5LF8c1LQ8H+
	 MjkbeQh8kGyEwzl4MkqAj65Kjqov1CqgkY7NWZR4Au0yDB6ITFJgoGOjXb7qDKrioz
	 QXr4NnFF51RRqS0HntjVekiBtWaStZYUc9djDryStaOQSejXt3bOOnVj7HFZ09zkDi
	 wh1mePA2bEvR5Q4qJ4bdoguR4f5XrN87PatXF7JM7YpFzEAj+dMJLMJiz791ksBdOw
	 UJWSoD3OJyRA37mcsPPnq7ZuZ1yvt4BNYLmgtRqPaCh65sVwfOkmod+DYUmKJuQgeC
	 l+KGiU5blju/A==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v4 0/7] objtool/klp: klp-build LTO support
Date: Thu,  5 Mar 2026 15:15:24 -0800
Message-ID: <20260305231531.3847295-1-song@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3A11D21934F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2137-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Add support for LTO in klp-build toolchain. The key changes are to the
symbol correlation logic.Basically, we want to:

1. Match symbols with differerent .llvm.<hash> suffixes, e.g., foo.llvm.123
   to foo.llvm.456.
2. Match local symbols with promoted global symbols, e.g., local foo
   with global foo.llvm.123.

1/7 and 2/7 are small cleanup/fix for existing code.
3/7 through 7/7 contains the core logic changes to correlate_symbols().

Changes v3 => v4:
1. Minor fixes in patches 1, 3, 7.
2. Only keep patches 1-7 for now, as there is ongoing discussion about the
   test infrastructure.

Changes v2 => v3:
1. Fix a bug in global => local correlations (patch 7/8).
2. Remove a WARN().
3. Some empty line changes.

Changes v1 => v2:
1. Error out on ambiguous .llvm.<hash>

Song Liu (7):
  objtool/klp: Remove redundant strcmp() in correlate_symbols()
  objtool/klp: Remove trailing '_' in demangle_name()
  objtool/klp: Use sym->demangled_name for symbol_name hash
  objtool/klp: Also demangle global objects
  objtool/klp: Remove .llvm suffix in demangle_name()
  objtool/klp: Match symbols based on demangled_name for global
    variables
  objtool/klp: Correlate locals to globals

 tools/objtool/elf.c                 | 95 ++++++++++++++++++++++-------
 tools/objtool/include/objtool/elf.h |  3 +
 tools/objtool/klp-diff.c            | 89 ++++++++++++++++++++++++++-
 3 files changed, 165 insertions(+), 22 deletions(-)

--
2.52.0

