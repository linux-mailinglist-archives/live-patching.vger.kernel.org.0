Return-Path: <live-patching+bounces-1507-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 138AAAD2BB5
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 04:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A236D7A7503
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 02:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84BE11A8419;
	Tue, 10 Jun 2025 02:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O8GU1EA8"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AFE7FBA1
	for <live-patching@vger.kernel.org>; Tue, 10 Jun 2025 02:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521172; cv=none; b=kJvvxoxJA9D6YmfS+T6JjYOIQyCKFnWeo3uymxcKH/tN89BKlgjm1rdG7iBU9i4DTm4x4S8GpUhSBiUSfA+5kf5RK0mMnGdj30Zg6Z0DE8u2x1q4lOb0rx5YPVRI8Qgcq6PtKhsnu7t8eXJrPh3UlhdlXvHVNu7ywh3qSWJNys0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521172; c=relaxed/simple;
	bh=E/mxtc1NiEdT6syW49gCT9eb0ZdmanNn8II47nz+Y4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NMOeE0BYwLu9Qlmgxd7yY/Y8HyoppHTw1u3De2fpE4ME5H0gxRQ/CIf7dArEvrEuI3g9aczRLWmsJRP93pgs62ed23lC2V9Sm0cP0nMVkEXoWEuakHdNnHeTrNUKWOYOrC6S3pylVv2kEptNbAHzFYbHWd603LzRfitSvlH8XwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O8GU1EA8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749521168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1zI7O1FheAtOAeHpPtctlaskG4exSg06LJYfOsk4Ek=;
	b=O8GU1EA8ro7fbSUjhblD72gnvVSF9zgpFpDUvOTzODeDCljwrl6A4C/uawRUZzAjhhKJvn
	i5xqKm0vm5rv+pFiYrqn+5lcS4wI8sDiVyiaI8JHB7V5YIRTXlSxjLZ8G/j+aaZbi1Y6hj
	SzP/pos+ARv5O3AzZ7xDUmCaJUNSzRQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-240-jm45h6FINROzS_M-qcLK1A-1; Mon,
 09 Jun 2025 22:06:04 -0400
X-MC-Unique: jm45h6FINROzS_M-qcLK1A-1
X-Mimecast-MFC-AGG-ID: jm45h6FINROzS_M-qcLK1A_1749521160
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29B46195608B;
	Tue, 10 Jun 2025 02:05:59 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.60])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1ABE118003FC;
	Tue, 10 Jun 2025 02:05:55 +0000 (UTC)
Date: Mon, 9 Jun 2025 22:05:53 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
Message-ID: <aEeTAa9qwCSdK9AD@redhat.com>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
 <aEdQNbqg2YMBFB8H@redhat.com>
 <7uriarhovgf3fp7tiidwklopqqk34ybk6fnhu6kncwtjgz2ni6@2z7m42t4oerw>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7uriarhovgf3fp7tiidwklopqqk34ybk6fnhu6kncwtjgz2ni6@2z7m42t4oerw>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Jun 09, 2025 at 04:59:37PM -0700, Josh Poimboeuf wrote:
> On Mon, Jun 09, 2025 at 05:20:53PM -0400, Joe Lawrence wrote:
> > If you touch sound/soc/sof/intel/, klp-build will error out with:
> > 
> >   Building patch module: livepatch-unCVE-2024-58012.ko
> >   ERROR: modpost: module livepatch-unCVE-2024-58012 uses symbol hda_dai_config from namespace SND_SOC_SOF_INTEL_HDA_COMMON, but does not import it.
> >   ERROR: modpost: module livepatch-unCVE-2024-58012 uses symbol hdac_bus_eml_sdw_map_stream_ch from namespace SND_SOC_SOF_HDA_MLINK, but does not import it.
> >   make[2]: *** [scripts/Makefile.modpost:145: /home/jolawren/src/centos-stream-10/klp-tmp/kmod/Module.symvers] Error 1
> >   make[1]: *** [/home/jolawren/src/centos-stream-10/Makefile:1936: modpost] Error 2
> >   make: *** [Makefile:236: __sub-make] Error 2
> > 
> > since the diff objects do not necessarily carry forward the namespace
> > import.
> 
> Nice, thanks for finding that.  I completely forgot about export
> namespaces.
> 
> Can you send me the patch for testing?  Is this the default centos10
> config?
> 

Yeah, cs-10 sets CONFIG_NAMESPACES=y.

The hack I posted earlier abused modinfo to get the namespaces.  You
could just dump the import_ns= strings in the .modinfo section with
readelf like (lightly tested):

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index f7d88726ed4f..671d1d07fd08 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -687,7 +687,9 @@ build_patch_module() {
 	cp -f "$SRC/scripts/livepatch/init.c" "$KMOD_DIR"
 
 	echo "obj-m := $NAME.o" > "$makefile"
-	echo -n "$NAME-y := init.o" >> "$makefile"
+	echo -n "$NAME-y := init.o namespaces.o" >> "$makefile"
+
+	echo "#include <linux/module.h>" >> "$KMOD_DIR/namespaces.c"
 
 	find "$DIFF_DIR" -type f -name "*.o" | mapfile -t files
 	[[ ${#files[@]} -eq 0 ]] && die "no changes detected"
@@ -695,8 +697,16 @@ build_patch_module() {
 	for file in "${files[@]}"; do
 		local rel_file="${file#"$DIFF_DIR"/}"
 		local kmod_file="$KMOD_DIR/$rel_file"
+		local namespaces=()
 		local cmd_file
 
+		# Copy symbol namespace
+		readelf -p .modinfo "$ORIG_DIR/$rel_file" | \
+			gawk -F= '/\<import_ns=/ {print $2}' | mapfile -t namespaces
+		for ns in "${namespaces[@]}"; do
+			echo "MODULE_IMPORT_NS(\"$ns\");" >> "$KMOD_DIR/namespaces.c"
+		done
+
 		mkdir -p "$(dirname "$kmod_file")"
 		cp -f "$file" "$kmod_file"


