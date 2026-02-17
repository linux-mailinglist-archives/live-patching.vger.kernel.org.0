Return-Path: <live-patching+bounces-2017-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cMsXDCaSlGl3FgIAu9opvQ
	(envelope-from <live-patching+bounces-2017-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:02 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B6FDC14DDE0
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ECB18300DF6E
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92E336AB58;
	Tue, 17 Feb 2026 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NB5SK4zk"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEC51D88AC
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344418; cv=none; b=ohys8Nt2jVmgghkuSTerJIj23y/h7A7oglJpRfAsRruS01TRj2dGvVeNETwHuvD4slLftN1Ab0NgVg8Llo2HMrt6nJkG3xlXlRG0J75WBQdI9DXjrCyiVZ+iBPlq7lfUqYU0rIK+FKTxz2yBLgBjulIGSe3HCK6dby2z0nA+PRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344418; c=relaxed/simple;
	bh=6xdt3n6jcSX9gzn4gN7qY3GpZo/nzBu2FH7oDRzdfOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=k9gFCdFY/pzW11zFMPxXlNQxFpkT/DpPNDuo29If5pbhip/Iz691Zwpi6FsMZeRpM3mU1OUg88Z8rXxnutaHReWpX/0sThgMPwYQxAWfN2WeCdwi32srcHwe7ePWqAlsQkWWLgVRGsByUixS5yGKYfFJT52SqL325Eaw5/7Hxsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NB5SK4zk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771344416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/sYo1qMkBtlu6sAGX6m4JVTKzydndLq0k/nXvTEw3g=;
	b=NB5SK4zkKAvEtLvfcNmm1qISqWqTltF8df6L9NB66dwmQqS/s92nnsS9L/wUKIZZEg1N9Z
	s8FnXl+8TC079VutvcK9PaTy0I7P4u9aSKbZAJIsTA+SXspQu1OicwYUFVKTm9JPPANuzm
	HZQRuVIWO2oYCBuFfdRjeBKthhNF/XU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-576-GH6UsPcfPuehesCx6A8CLQ-1; Tue,
 17 Feb 2026 11:06:53 -0500
X-MC-Unique: GH6UsPcfPuehesCx6A8CLQ-1
X-Mimecast-MFC-AGG-ID: GH6UsPcfPuehesCx6A8CLQ_1771344411
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9E2318005AD;
	Tue, 17 Feb 2026 16:06:51 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.197])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 63A7130001A5;
	Tue, 17 Feb 2026 16:06:50 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 01/13] objtool/klp: honor SHF_MERGE entry alignment in elf_add_data()
Date: Tue, 17 Feb 2026 11:06:32 -0500
Message-ID: <20260217160645.3434685-2-joe.lawrence@redhat.com>
In-Reply-To: <20260217160645.3434685-1-joe.lawrence@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2017-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: B6FDC14DDE0
X-Rspamd-Action: no action

When adding data to an SHF_MERGE section, set the Elf_Data d_align to
the section's sh_addralign so libelf aligns entries within the section.
This ensures that entry offsets are consistent with previously calculated
relocation addends.

Fixes: 431dbabf2d9d ("objtool: Add elf_create_data()")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/objtool/elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 2c02c7b49265..bd6502e7bdc0 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1375,7 +1375,7 @@ void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_
 		memcpy(sec->data->d_buf, data, size);
 
 	sec->data->d_size = size;
-	sec->data->d_align = 1;
+	sec->data->d_align = (sec->sh.sh_flags & SHF_MERGE) ? sec->sh.sh_addralign : 1;
 
 	offset = ALIGN(sec->sh.sh_size, sec->sh.sh_addralign);
 	sec->sh.sh_size = offset + size;
-- 
2.53.0


