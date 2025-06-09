Return-Path: <live-patching+bounces-1504-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B641AAD28A5
	for <lists+live-patching@lfdr.de>; Mon,  9 Jun 2025 23:21:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C40217A7AF2
	for <lists+live-patching@lfdr.de>; Mon,  9 Jun 2025 21:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2782223710;
	Mon,  9 Jun 2025 21:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jfc3cPKJ"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2892222C7
	for <live-patching@vger.kernel.org>; Mon,  9 Jun 2025 21:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749504071; cv=none; b=Zp/xqyMat8Ye5c4KGjKDWP89mFJ94lesxokdY9dtAecj4uWCBj0ZUqnJ3MtkD1G401ZShRRTOf+5unnI2xuSja2CSFybEbKb3L+Rg5DZyaRQ9ILn9i5NqMN3dRue2cu+FgK34gQsRZi1wtgZlHv+h0ePP0fB+oBVM2UlIP1oqYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749504071; c=relaxed/simple;
	bh=wWbwNAYP79yY5ooKOUIK/EloFfKxdRk81tpD/qS3JE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xp0bDvd72f2ndNgs6rDuodiqVm9Kkeh3M55eNbfoNgH2Y9s8pTji84Hsf8x+Pg1O7Z319jW9suCXqHgVzIcNUD1+M0r38xM0sx8nauMeM9PakR8wmQ+CwThrb+kKfdlJKB2d/B2NHvdgnHFpuyScdesXoI7sgyVxZUhfgfBGeKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jfc3cPKJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749504068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aOqvn2UvMFTAJZ8bSI/XHl8AOmDk5n8DI4dSJCysvV8=;
	b=Jfc3cPKJXwWOr+Mi92d9XV1G5aItrISnNBLvYKxoORjDpgASeY9qsVpHJSnY9P+mvqbfnN
	jn5NasESt/Mhor6JpVJu0Ia4wfcGaakxVwA5Yt/h+PKfaJhy24gd8kdN81OqfuH21qN35b
	qOa3obi0YmUfUA9+6hqQ2PzRKuAvBvM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-325-G1ViSkazOhW_P9GZP4pb3A-1; Mon,
 09 Jun 2025 17:21:02 -0400
X-MC-Unique: G1ViSkazOhW_P9GZP4pb3A-1
X-Mimecast-MFC-AGG-ID: G1ViSkazOhW_P9GZP4pb3A_1749504060
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E5781956080;
	Mon,  9 Jun 2025 21:20:59 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.60])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E9E719560AB;
	Mon,  9 Jun 2025 21:20:56 +0000 (UTC)
Date: Mon, 9 Jun 2025 17:20:53 -0400
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
Message-ID: <aEdQNbqg2YMBFB8H@redhat.com>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, May 09, 2025 at 01:17:23PM -0700, Josh Poimboeuf wrote:
> +# Build and post-process livepatch module in $KMOD_DIR
> +build_patch_module() {
> +	local makefile="$KMOD_DIR/Kbuild"
> +	local log="$KMOD_DIR/build.log"
> +	local cflags=()
> +	local files=()
> +	local cmd=()
> +
> +	rm -rf "$KMOD_DIR"
> +	mkdir -p "$KMOD_DIR"
> +
> +	cp -f "$SRC/scripts/livepatch/init.c" "$KMOD_DIR"
> +
> +	echo "obj-m := $NAME.o" > "$makefile"
> +	echo -n "$NAME-y := init.o" >> "$makefile"
> +
> +	find "$DIFF_DIR" -type f -name "*.o" | mapfile -t files
> +	[[ ${#files[@]} -eq 0 ]] && die "no changes detected"
> +
> +	for file in "${files[@]}"; do
> +		local rel_file="${file#"$DIFF_DIR"/}"
> +		local kmod_file="$KMOD_DIR/$rel_file"
> +		local cmd_file
> +
> +		mkdir -p "$(dirname "$kmod_file")"
> +		cp -f "$file" "$kmod_file"
> +
> +		# Tell kbuild this is a prebuilt object
> +		cp -f "$file" "${kmod_file}_shipped"
> +
> +		echo -n " $rel_file" >> "$makefile"
> +
> +		cmd_file="$ORIG_DIR/$(dirname "$rel_file")/.$(basename "$rel_file").cmd"
> +		[[ -e "$cmd_file" ]] && cp -f "$cmd_file" "$(dirname "$kmod_file")"
> +	done
> +
> +	echo >> "$makefile"
> +
> +	cflags=("-ffunction-sections")
> +	cflags+=("-fdata-sections")
> +	[[ $REPLACE -eq 0 ]] && cflags+=("-DKLP_NO_REPLACE")
> +
> +	cmd=("make")
> +	cmd+=("$VERBOSE")
> +	cmd+=("-j$CPUS")
> +	cmd+=("--directory=.")
> +	cmd+=("M=$KMOD_DIR")
> +	cmd+=("KCFLAGS=${cflags[*]}")
> +
> +	# Build a "normal" kernel module with init.c and the diffed objects
> +	(
> +		cd "$SRC"
> +		"${cmd[@]}"							\
> +			>  >(tee -a "$log")					\
> +			2> >(tee -a "$log" >&2)
> +	)
> +
> +	# Save off the intermediate binary for debugging
> +	cp -f "$KMOD_DIR/$NAME.ko" "$KMOD_DIR/$NAME.ko.orig"
> +
> +	# Fix (and work around) linker wreckage for klp syms / relocs
> +	"$SRC/tools/objtool/objtool" klp post-link "$KMOD_DIR/$NAME.ko" || die "objtool klp post-link failed"
> +
> +	cp -f "$KMOD_DIR/$NAME.ko" "$OUTFILE"
> +}

Hi Josh,

Another small bug feature? report: module symbol namespaces.

If you touch sound/soc/sof/intel/, klp-build will error out with:

  Building patch module: livepatch-unCVE-2024-58012.ko
  ERROR: modpost: module livepatch-unCVE-2024-58012 uses symbol hda_dai_config from namespace SND_SOC_SOF_INTEL_HDA_COMMON, but does not import it.
  ERROR: modpost: module livepatch-unCVE-2024-58012 uses symbol hdac_bus_eml_sdw_map_stream_ch from namespace SND_SOC_SOF_HDA_MLINK, but does not import it.
  make[2]: *** [scripts/Makefile.modpost:145: /home/jolawren/src/centos-stream-10/klp-tmp/kmod/Module.symvers] Error 1
  make[1]: *** [/home/jolawren/src/centos-stream-10/Makefile:1936: modpost] Error 2
  make: *** [Makefile:236: __sub-make] Error 2

since the diff objects do not necessarily carry forward the namespace
import.

There's several options to how to handle it (cross-reference with
Modules.symvers, copy out the .modinfo sections, include the section in
the diff .o, etc.) ... my late afternoon hack just snarfed it from the
original objects with a modinfo hack.  Anyway, you get the idea.

-- Joe

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

@@ -687,7 +700,9 @@ build_patch_module() {
 	cp -f "$SRC/scripts/livepatch/init.c" "$KMOD_DIR"
 
 	echo "obj-m := $NAME.o" > "$makefile"
-	echo -n "$NAME-y := init.o" >> "$makefile"
+
+	echo "#include <linux/module.h>" >> "$KMOD_DIR/namespaces.c"
+	echo -n "$NAME-y := init.o namespaces.o" >> "$makefile"
 
 	find "$DIFF_DIR" -type f -name "*.o" | mapfile -t files
 	[[ ${#files[@]} -eq 0 ]] && die "no changes detected"
@@ -697,6 +712,13 @@ build_patch_module() {
 		local kmod_file="$KMOD_DIR/$rel_file"
 		local cmd_file
 
+		# Symbol namespace hack
+		echo ln -s -f "$file" ns-temp.ko
+		ln -s -f "$ORIG_DIR/$rel_file" ns-temp.ko
+		for ns in $(modinfo ns-temp.ko -F import_ns); do
+			echo "MODULE_IMPORT_NS(\"$ns\");" >> "$KMOD_DIR/namespaces.c"
+		done
+
 		mkdir -p "$(dirname "$kmod_file")"
 		cp -f "$file" "$kmod_file"
 
--
Joe


