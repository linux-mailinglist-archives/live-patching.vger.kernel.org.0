Return-Path: <live-patching+bounces-652-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A2FC976D85
	for <lists+live-patching@lfdr.de>; Thu, 12 Sep 2024 17:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98255B21A7D
	for <lists+live-patching@lfdr.de>; Thu, 12 Sep 2024 15:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D1A1B3F3A;
	Thu, 12 Sep 2024 15:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bdppqrwP"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE2A1B12E4
	for <live-patching@vger.kernel.org>; Thu, 12 Sep 2024 15:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726154124; cv=none; b=EegEhzaK66Ro1KIvIbpgXAAZfWJs24CsxpvlX1Q0gWaqipkQWruoJ7yLytf1hIu/BWqeHDWDkUvELLpOET58Zg2KIxgBBU1SOqxSC3uh5eWlcWq0T9cqvjXHNtTjsJk2cSgX6nOfxsjIKiZFALOT7eJMD0UCyScWNwM2zS/mFh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726154124; c=relaxed/simple;
	bh=fKlbVxrRCiEwCFvfv1wJmQCFWNefqs0T4sbP1rJqPIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q7BdIX/z1Noz2sIWz9w9J6PTb06TcSUW755KloGCsSZ/EDeekk2lwAqvQT7szGriNgLkupimTCxW0r0GST454Ln3VhKHMDh/3VaiKloBgZqwMSkUzUiA5IYci1ai4UfcSpVqAtIIpPfwuy6bQLQO46gRxDA2rYlVgvzfso2Zo9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdppqrwP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726154121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4ycrK4MsOQKe0pFFMEcK7ih1jRYPQRfevGKgVDDTft8=;
	b=bdppqrwPJ6k0KoSPqP8JbsKwtV1w/OhezoyD9mXNLmHcQkzID85T0rLuQIR9Q4rgdQEWyr
	3HWNXEW07RVWgwhy+Ie/LScerqGcfvTrd9BZYKLeNOPY9btPLbdgwAYcyp+TIsZM/NNjiY
	3IbwktOGzc3yizcld79cAXs1MaGO0lw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-HLLsmy-TNwqlEkpMsV7FXA-1; Thu,
 12 Sep 2024 11:15:14 -0400
X-MC-Unique: HLLsmy-TNwqlEkpMsV7FXA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 192D41956083;
	Thu, 12 Sep 2024 15:15:13 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.105])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B0841956053;
	Thu, 12 Sep 2024 15:15:11 +0000 (UTC)
Date: Thu, 12 Sep 2024 11:15:08 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Lukas Hruska <lhruska@suse.cz>
Cc: pmladek@suse.com, mbenes@suse.cz, jpoimboe@kernel.org,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, mpdesouza@suse.com
Subject: Re: [PATCH v3 0/6] livepatch: klp-convert tool - Minimal version
Message-ID: <ZuMFfJkCkZ4+9505@redhat.com>
References: <20240827123052.9002-1-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827123052.9002-1-lhruska@suse.cz>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Aug 27, 2024 at 02:30:45PM +0200, Lukas Hruska wrote:
> Summary
> -------
> 
> This is a significantly simplified version of the original klp-convert tool.
> The klp-convert code has never got a proper review and also clean ups
> were not easy. The last version was v7, see
> https://lore.kernel.org/r/20230306140824.3858543-1-joe.lawrence@redhat.com
> 
> The main change is that the tool does not longer search for the
> symbols which would need the livepatch specific relocation entry.
> Also klp.symbols file is not longer needed.
> 
> Instead, the needed information is appended to the symbol declaration
> via a new macro KLP_RELOC_SYMBOL(). It creates symbol with all needed
> metadata. For example:
> 
>   extern char *saved_command_line \
>                  KLP_RELOC_SYMBOL(vmlinux, vmlinux, saved_command_line, 0);
> 
> would create symbol
> 
> $>readelf -r -W <compiled livepatch module>:
> Relocation section '.rela.text' at offset 0x32e60 contains 10 entries:
>     Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
> [...]
> 0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.rela.vmlinux.vmlinux.saved_command_line,0 - 4
> [...]
> 
> 
> The simplified klp-convert tool just transforms symbols
> created by KLP_RELOC_SYMBOL() to object specific rela sections
> and rela entries which would later be proceed when the livepatch
> or the livepatched object is loaded.
> 
> For example, klp-convert would replace the above symbols with:
> 
> $> readelf -r -W <livepatch_module_proceed_by_klp_convert>
> Relocation section '.klp.rela.vmlinux.text' at offset 0x5cb60 contains 1 entry:
>     Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
> 0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4
> 
> 
> Note that similar macro was needed also in the original version
> to handle more symbols of the same name (sympos).
> 
> Given the above, add klp-convert tool; integrate klp-convert tool into
> kbuild; add data-structure and macros to enable users to annotate
> livepatch source code; make modpost stage compatible with livepatches;
> update livepatch-sample and update documentation.
> 
> 
> Testing
> -------
> 
> The patchset selftests build and execute on x86_64, s390x, and ppc64le
> for both default config (with added livepatch dependencies) and a larger
> SLE-15-ish config.
> 
> 
> Summary of changes in this minimal version v3
> ------------------------
> 
> - klp-convert: symbol format changes (suggested by jlawrence)
> - samples: fixed name of added sample in Makefile (suggested by pmladek)
> - selftests: added ibt test case as an example (DON'T MERGE)
> - fixed all suggested small changes in v2
> 
> Previous versions
> -----------------
> 
> RFC:
>   https://lore.kernel.org/r/cover.1477578530.git.jpoimboe@redhat.com/
> v2:
>   https://lore.kernel.org/r/f52d29f7-7d1b-ad3d-050b-a9fa8878faf2@redhat.com/
> v3:
>   https://lore.kernel.org/r/20190410155058.9437-1-joe.lawrence@redhat.com/
> v4:
>   https://lore.kernel.org/r/20190509143859.9050-1-joe.lawrence@redhat.com/
> v5:
>   (not posted)
>   https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v5-devel
> v6:
>   https://lore.kernel.org/r/20220216163940.228309-1-joe.lawrence@redhat.com/
> v7:
>   https://lore.kernel.org/r/20230306140824.3858543-1-joe.lawrence@redhat.com/
> v1 minimal:
>   https://lore.kernel.org/r/20231106162513.17556-1-lhruska@suse.cz/
> v2 minimal:
>   https://lore.kernel.org/r/20240516133009.20224-1-lhruska@suse.cz/
> 

Hi Lukas,

Thanks again for posting the patchset and trying a simpler approach.

I tested with latest kpatch-build tree with no ill effects --
essentially klp-convert is safe to run against .ko files that already
contain klp-relocations.

I would prefer more extensive selftests for various klp-relocation types
(as well as symbol position), however I believe wasn't the point of the
minimal version of this patchset.  We can add more tests later.

Anyway, now we have two RFC / patchsets supporting in-tree creation of
klp-relocations (klp-convert and Josh's objtool patchset).  I think we
need to figure out whether one precludes the other, can they co-exist,
or does that even make sense.

Since LPC is right around the corner, does it make sense for folks to
sync up at some point and talk pros/cons to various approaches?  We
don't have a microconference this year, but perhaps over lunch or beers?

--
Joe


