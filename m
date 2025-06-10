Return-Path: <live-patching+bounces-1511-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA8FAD3DBE
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 17:45:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B3EE1893E67
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 15:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B0C22D4E2;
	Tue, 10 Jun 2025 15:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSJhr4RF"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1B1211A1E;
	Tue, 10 Jun 2025 15:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749570121; cv=none; b=LGcsF3ECnir8Ul7U0Gsn1hhkB03TrzhmTvqmunjwFnbNuI9uLZHbfniv8xqGEYqPgvmPOW9wJblRN5iRtuSenKQhetOQJXRFTfQP235mrWRCwUIQUI/3V7RX4FQk37JuGoXr2pKPc412XZmjBuZs5NeO4GVTTJpGsOq8Td2cqCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749570121; c=relaxed/simple;
	bh=eEXAvPCSdlDVm0vDSvoWviXhEnVX240x3wlBNcfcZfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTwfQqvxuRcZKP+0gZgLOEMRjXdGHioGVIVW59ws0CH/XtzAh1ZKkFjIU4mv3qfIVkTnbpowJTyM+6ME2as4V/V+4Vod57L077tNyK4UXtFEEpczEusscz5mzN4TT+VXkJlr3g9HY48WIvEAA9WhhQx+Mi/sO/MNXgs1hPEHJsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSJhr4RF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FE7C4CEED;
	Tue, 10 Jun 2025 15:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749570121;
	bh=eEXAvPCSdlDVm0vDSvoWviXhEnVX240x3wlBNcfcZfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mSJhr4RFHyNxXQhRIp9c3TAV+6fFyMjQg5SXsXlsXfcpWbOjM0IA1yYP6xKsRIg9m
	 mwGDxWwZWgQHWA3m0BcFdX/xgQ/gegOCprIFlx9JbwhsILbu+Q1VHBCNV4qEyxLUAW
	 ZzsbLVCbz/oap/yxMhm+wx5g4etdJ6kB8kg1McVL3tsxudzm3iaYtc01gFHtrYHWWG
	 WQwWUUu5/SBWmd1126H4iccoDYVWWSN3wAX5t+tbvRY+dysYPH5Lm/Ra/cf37GAoEu
	 VT2PSz5zFQ+5I8Ic1qVgo8LFQmK1YHcep6KdbhBHcPJDs9vMw5QQ1cn/osNGVpk6Qw
	 b1ZVdO9DdjRow==
Date: Tue, 10 Jun 2025 08:41:58 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
Message-ID: <rizzd27l4t4yyvkzupn7ngjtfz7rzajr7cfsonmmyijhelrxv6@zp4uav5bwejl>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
 <aEdQNbqg2YMBFB8H@redhat.com>
 <7uriarhovgf3fp7tiidwklopqqk34ybk6fnhu6kncwtjgz2ni6@2z7m42t4oerw>
 <aEeTAa9qwCSdK9AD@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aEeTAa9qwCSdK9AD@redhat.com>

On Mon, Jun 09, 2025 at 10:05:53PM -0400, Joe Lawrence wrote:
> On Mon, Jun 09, 2025 at 04:59:37PM -0700, Josh Poimboeuf wrote:
> > On Mon, Jun 09, 2025 at 05:20:53PM -0400, Joe Lawrence wrote:
> > > If you touch sound/soc/sof/intel/, klp-build will error out with:
> > > 
> > >   Building patch module: livepatch-unCVE-2024-58012.ko
> > >   ERROR: modpost: module livepatch-unCVE-2024-58012 uses symbol hda_dai_config from namespace SND_SOC_SOF_INTEL_HDA_COMMON, but does not import it.
> > >   ERROR: modpost: module livepatch-unCVE-2024-58012 uses symbol hdac_bus_eml_sdw_map_stream_ch from namespace SND_SOC_SOF_HDA_MLINK, but does not import it.
> > >   make[2]: *** [scripts/Makefile.modpost:145: /home/jolawren/src/centos-stream-10/klp-tmp/kmod/Module.symvers] Error 1
> > >   make[1]: *** [/home/jolawren/src/centos-stream-10/Makefile:1936: modpost] Error 2
> > >   make: *** [Makefile:236: __sub-make] Error 2
> > > 
> > > since the diff objects do not necessarily carry forward the namespace
> > > import.
> > 
> > Nice, thanks for finding that.  I completely forgot about export
> > namespaces.
> > 
> > Can you send me the patch for testing?  Is this the default centos10
> > config?
> > 
> 
> Yeah, cs-10 sets CONFIG_NAMESPACES=y.
> 
> The hack I posted earlier abused modinfo to get the namespaces.  You
> could just dump the import_ns= strings in the .modinfo section with
> readelf like (lightly tested):

Sorry, I wasn't clear, I meant the original .patch for recreating the
issue.  But that's ok, I think the below fix should work.

This is basically the same approach as yours, but in klp-diff.  It copies
from the patched object instead of the orig object in case the patch
needs to add an IMPORT_NS().

I also experimented with reading the namespaces from Module.symvers, and
then adding them on demand for exported symbols in clone_symbol().  But
this is simpler.

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index a1c72824f442..3139f1ebacce 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1490,6 +1490,51 @@ static int create_klp_sections(struct elfs *e)
 	return 0;
 }
 
+/*
+ * Copy all .modinfo import_ns= tags to ensure all namespaced exported symbols
+ * can be accessed via normal relocs.
+ */
+static int copy_import_ns(struct elfs *e)
+{
+	struct section *patched_sec, *out_sec = NULL;
+	char *import_ns, *data_end;
+
+	patched_sec = find_section_by_name(e->patched, ".modinfo");
+	if (!patched_sec)
+		return 0;
+
+	import_ns = patched_sec->data->d_buf;
+	if (!import_ns)
+		return 0;
+
+	for (data_end = import_ns + sec_size(patched_sec);
+	     import_ns < data_end;
+	     import_ns += strlen(import_ns) + 1) {
+
+		import_ns = memmem(import_ns, data_end - import_ns, "import_ns=", 10);
+		if (!import_ns)
+			return 0;
+
+		if (!out_sec) {
+			out_sec = find_section_by_name(e->out, ".modinfo");
+			if (!out_sec) {
+				out_sec = elf_create_section(e->out, ".modinfo", 0,
+							     patched_sec->sh.sh_entsize,
+							     patched_sec->sh.sh_type,
+							     patched_sec->sh.sh_addralign,
+							     patched_sec->sh.sh_flags);
+				if (!out_sec)
+					return -1;
+			}
+		}
+
+		if (!elf_add_data(e->out, out_sec, import_ns, strlen(import_ns) + 1))
+			return -1;
+	}
+
+	return 0;
+}
+
 int cmd_klp_diff(int argc, const char **argv)
 {
 	struct elfs e = {0};
@@ -1539,6 +1584,9 @@ int cmd_klp_diff(int argc, const char **argv)
 	if (create_klp_sections(&e))
 		return -1;
 
+	if (copy_import_ns(&e))
+		return -1;
+
 	if  (elf_write(e.out))
 		return -1;
 

