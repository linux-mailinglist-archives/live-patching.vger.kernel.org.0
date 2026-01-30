Return-Path: <live-patching+bounces-1936-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOhXJAEDfWl5PwIAu9opvQ
	(envelope-from <live-patching+bounces-1936-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:14:09 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A701BE0D8
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:14:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E29E83035887
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE54387570;
	Fri, 30 Jan 2026 19:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qE8ktFKN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9924038737D
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 19:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769800446; cv=none; b=JLHlHxHMJdV5ayxxCYsGlEzLlsrwHmVPxrTAWQJHjZ1ujCVvYPr3WqThxsyJ0eKrQSiefUP+1lg6hzi4xj03ZoyxdoojuiOb3McYG/+NToFlre95y+GCMLHrhdBPV63Wwz6w3dg+Y8F8fU/MMdl+gVF3E5PxroHfPWqqRLoPkUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769800446; c=relaxed/simple;
	bh=gySfJfeG9aEiTz3tL/SkmjqSJDt1mX2H6i5VlWIMrbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RiS+owd2evDoVe2GKpESetnHUklok2ni4bSvxKwZXlO+6WoxTGRqh/Xws2xydVGuADMMkqFY0E4JtcZLVOAa8lO+XabDiOMvqG0pSLEFkMSqQxEBIma9wE+MqbMCMU5pIwfn1gko+mvJi5UdH5aEvlkwGZ9wSZf950mh6PpGyjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qE8ktFKN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EA7C4CEF7
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 19:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769800446;
	bh=gySfJfeG9aEiTz3tL/SkmjqSJDt1mX2H6i5VlWIMrbs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qE8ktFKNu1xCo5piow4mN1srIf7iJmeKBeZS6E18N0GS9zd3AqJcXO+bnM3yp/x9y
	 nDVfkN4stcJRIOx1QMTg+DUKEpdo7vRah3g5jG5pA4rL0rQlD9xWmkTvdX8rorrCft
	 koPyGhi/6yqRdKzfwrTpgAr9AzM82awJWZjk3wmekIPt1mn/qqAcrmclBddZS5mdTU
	 zmEwVsTOTYk9idrXtVbjgMkNGELQdq2qauCxGHP28VagWw1LqsCnRC0Vhe9MdFYU2Z
	 SzyfHM9Fv13BzLduQw/dvu/GQPHC1VS8I1uDPTl/tPLr6UKV4GO2XIDdgWrvGVcsy1
	 wzbaVOkW3A31A==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-894676e6863so29678656d6.2
        for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 11:14:06 -0800 (PST)
X-Gm-Message-State: AOJu0YylMsFo1hExw8G1FNCBDluGgVbCs0k8lFJnHdOD5DWLtY3aChWn
	IHk/xaHhbOhyQSAxGZkb/e+3h+7NfkRnDHWzI4NPRtfWcCica4h4q889SbIKp9xYdsGb7nN2V6U
	srbOpaj2NBogHuYhuZnCMEdTVPINy/ZA=
X-Received: by 2002:ad4:5aa9:0:b0:894:6eea:709c with SMTP id
 6a1803df08f44-894e9f268d7mr53860016d6.8.1769800445660; Fri, 30 Jan 2026
 11:14:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130175950.1056961-1-joe.lawrence@redhat.com> <20260130175950.1056961-5-joe.lawrence@redhat.com>
In-Reply-To: <20260130175950.1056961-5-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Fri, 30 Jan 2026 11:13:53 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5E8z5DCuCVdxvgTEYRAfgj7dapqzTdjzptmfbNM5YCOQ@mail.gmail.com>
X-Gm-Features: AZwV_Qj10tMj1c7jKrT6gCXpbsAbDrZ_PU9R4acpQkDyQtp2xyG3w5heCskzpYw
Message-ID: <CAPhsuW5E8z5DCuCVdxvgTEYRAfgj7dapqzTdjzptmfbNM5YCOQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] objtool/klp: add -z/--fuzz patch rebasing option
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1936-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0A701BE0D8
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 10:00=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.=
com> wrote:
>
> The klp-build script is currently very strict with input patches,
> requiring them to apply cleanly via `git apply --recount`.  This
> prevents the use of patches with minor contextual fuzz relative to the
> target kernel sources.
>
> Add an optional -z/--fuzz option to allow klp-build to "rebase" input
> patches within its klp-tmp/ scratch space.  When enabled, the script
> utilizes GNU patch's fuzzy matching to apply changes to a temporary
> directory and then creates a normalized version of the patch using `git
> diff --no-index`.
>
> This rebased patch contains the exact line counts and context required
> for the subsequent klp-build fixup and build steps, allowing users to
> reuse a patch across similar kernel streams.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

LTGM.

Acked-by: Song Liu <song@kernel.org>

With one nitpick below.
[...]
>
> +# Rebase a patch using GNU patch with fuzz
> +# Outputs path to rebased patch on success, non-zero on failure
> +rebase_patch() {
> +       local idx=3D"$1"
> +       local input_patch=3D"$2"
> +       local patch_name=3D"$(basename "$input_patch" .patch)"
> +       local work_dir=3D"$REBASE_DIR/$idx-$patch_name"
> +       local output_patch=3D"$work_dir/rebased.patch"
> +       local files=3D()
> +       local file
> +
> +       rm -rf "$work_dir"
> +       mkdir -p "$work_dir/orig" "$work_dir/patched"
> +
> +       get_patch_files "$input_patch" | mapfile -t files
> +
> +       # Copy original files (before patch)
> +       for file in "${files[@]}"; do
> +               [[ "$file" =3D=3D "dev/null" ]] && continue
> +               if [[ -f "$SRC/$file" ]]; then
> +                       mkdir -p "$work_dir/orig/$(dirname "$file")"
> +                       cp -f "$SRC/$file" "$work_dir/orig/$file"
> +               fi
> +       done
> +
> +       # Apply with fuzz
> +       (
> +               cd "$SRC"
> +               sed -n '/^-- /q;p' "$input_patch" | \
> +                       patch -p1 \

I think we should add -s here, and.

> +                               -F"$FUZZ_FACTOR" \
> +                               --no-backup-if-mismatch \
> +                               -r /dev/null \
> +                               --forward >&2
> +       ) || return 1
> +
> +       # Copy patched files (after patch)
> +       for file in "${files[@]}"; do
> +               [[ "$file" =3D=3D "dev/null" ]] && continue
> +               if [[ -f "$SRC/$file" ]]; then
> +                       mkdir -p "$work_dir/patched/$(dirname "$file")"
> +                       cp -f "$SRC/$file" "$work_dir/patched/$file"
> +               fi
> +       done
> +
> +       # Revert with fuzz
> +       (
> +               cd "$SRC"
> +               sed -n '/^-- /q;p' "$input_patch" | \
> +                       patch -p1 -R \

.. here, so that we can avoid a bunch of "patching file" messages.

> +                               -F"$FUZZ_FACTOR" \
> +                               --no-backup-if-mismatch \
> +                               -r /dev/null >&2
> +       ) || {
> +               warn "fuzzy revert failed; source tree may be corrupted"
> +               return 1
> +       }

