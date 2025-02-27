Return-Path: <live-patching+bounces-1242-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B26FA4837D
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 16:49:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11C72172676
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 15:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B056190470;
	Thu, 27 Feb 2025 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="qJVr79NW"
X-Original-To: live-patching@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52431624C3;
	Thu, 27 Feb 2025 15:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740671348; cv=none; b=BWO/Nc7gMmvcA+TdMsMxjzyLkJX/tR1J+I3h3NXqsBHRFLF1GXILxp7JAIX3GekhAHFhuj4V4HfZuaCEPa/WV8XItEaZiWeH0anuvpM1RF9NG7Pt6gcK9n2A5TcR//nnyO+t6BxJBya4Iwkeja8VBiUdhttkn1pTGxmqUsTm23E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740671348; c=relaxed/simple;
	bh=zzZa7n5QAPPWcKQ/es+FdPtKkvbVk123mv32pczukr0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SuqsgE1+ZwwOnygGSijClVyREMXU6Uj//7sq8wS/Am6MMB6/Qa+ZjUlIOyp8dxiuX5NICHCAtxO3zbB6D0EoTJt2Z6YBg2moXFNapTidInde9jhjH+9ZKolBmcj8UiKaCLdQHNHJj0IO5Fci1utEl9oPURCAj1MmHoZ4TSOAGtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=qJVr79NW; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 28826411AF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1740671336; bh=cqbT2RBDltaoqj4UWGIofvpGfTET89voDdxor1L4E9Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=qJVr79NWJC/fbAi0+wjIfIVYMHAG8JeG/0T1+dFeN+xSPR8jqABgBC7koYbVLA3X8
	 btow3rPgJRp9d46U/v97sGxcz6fhXQRLMS3xXTy+gqaY30mhW+73BRLY4j+LhVIyBO
	 +F6gDJTk1KHaqe1Tz6ncIu+IeBcr/v98jcqdcI3wrhBQpd9grR73cLH0/Q5ToFoQ3T
	 DVdMBxnkLbtmPSE4eZa9zqbH4pkH3+j27bpSfkPBEjqcysL0xORu60i4+sDgDzUhdg
	 UaIg66B+DCpdIwv13NfK0i9hDlrhEuBpmjtN+44Zr+BYuqfU0tonyVlXGaoOZLqpFg
	 rdAY2BxWPRD7w==
Received: from localhost (unknown [IPv6:2601:280:4600:2d7f::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 28826411AF;
	Thu, 27 Feb 2025 15:48:56 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Vincenzo MEZZELA <vincenzo.mezzela@suse.com>,
 live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com, Vincenzo MEZZELA <vincenzo.mezzela@suse.com>
Subject: Re: [PATCH] docs: livepatch: move text out of code block
In-Reply-To: <20250227150328.124438-1-vincenzo.mezzela@suse.com>
References: <20250227150328.124438-1-vincenzo.mezzela@suse.com>
Date: Thu, 27 Feb 2025 08:48:55 -0700
Message-ID: <87bjunqtg8.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Vincenzo MEZZELA <vincenzo.mezzela@suse.com> writes:

> Part of the documentation text is included in the readelf output code
> block. Hence, split the code block and move the affected text outside.
>
> Signed-off-by: Vincenzo MEZZELA <vincenzo.mezzela@suse.com>
> ---
>  Documentation/livepatch/module-elf-format.rst | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
> index a03ed02ec57e..eadcff224335 100644
> --- a/Documentation/livepatch/module-elf-format.rst
> +++ b/Documentation/livepatch/module-elf-format.rst
> @@ -217,16 +217,23 @@ livepatch relocation section refer to their respective symbols with their symbol
>  indices, and the original symbol indices (and thus the symtab ordering) must be
>  preserved in order for apply_relocate_add() to find the right symbol.
>  
> -For example, take this particular rela from a livepatch module:::
> +For example, take this particular rela from a livepatch module:
> +
> +::

The right fix here is to just delete the extra ":"

>    Relocation section '.klp.rela.btrfs.text.btrfs_feature_attr_show' at offset 0x2ba0 contains 4 entries:
>        Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
>    000000000000001f  0000005e00000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.printk,0 - 4
>  
> -  This rela refers to the symbol '.klp.sym.vmlinux.printk,0', and the symbol index is encoded
> -  in 'Info'. Here its symbol index is 0x5e, which is 94 in decimal, which refers to the
> -  symbol index 94.
> -  And in this patch module's corresponding symbol table, symbol index 94 refers to that very symbol:
> +This rela refers to the symbol '.klp.sym.vmlinux.printk,0', and the symbol
> +index is encoded in 'Info'. Here its symbol index is 0x5e, which is 94 in
> +decimal, which refers to the symbol index 94.
> +
> +And in this patch module's corresponding symbol table, symbol index 94 refers
> +to that very symbol:
> +
> +::

You can put that extra colon here rather than introducing a separate
"::" line.

Thanks,

jon

