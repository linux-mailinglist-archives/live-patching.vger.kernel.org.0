Return-Path: <live-patching+bounces-2042-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOhkDbPElGmqHgIAu9opvQ
	(envelope-from <live-patching+bounces-2042-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 20:42:43 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CA86114FB3C
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 20:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7B5DE3016ECA
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 19:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59ED8377575;
	Tue, 17 Feb 2026 19:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCGqm/lm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FA229C35A
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 19:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771357354; cv=none; b=HJDR0HYrgtEOHqidO76HFged5hArDPuVmMzxgvN72EvtM1TB+xcQhLrwV6xk62jAJ8tyaNi8VB+te89Jod6GcP/NKFKz1a7cQE1J1JlKRjcUYdZZYimvr8w1yUtnTgpsosmy8cVVsV+GqVbQPUxh/OmLw2WsdGKDnmnulDJEcnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771357354; c=relaxed/simple;
	bh=0FNTy0AeYeAX9sTsvOH1uY4mRC5gqlq9eQWiA7AopEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TCZI6cr7d5/Kr0AgKBLkhpT9roNROOS4JCLwHqYyeiCmyJSxIxach/AA+/Tg9IBgUubl+gfwvr6LxgpQkqT/zpOVRkUVWY2ppTnWAa2tdEXFpgc4CGHYPYub8XomTUrxWSE62v8vS2C9o2gRXed02/9MdQlN/LkDcFn5XT/0QcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vCGqm/lm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC269C19425
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 19:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771357353;
	bh=0FNTy0AeYeAX9sTsvOH1uY4mRC5gqlq9eQWiA7AopEw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vCGqm/lmvF1loicxLnlHoTOY/hv2JmnQgZvKC82uPTY1WOu8K9TR1Ud6ZBsvQRFhm
	 10ba50ycG6ZDFe6ibDVDVMvsBIND9FxEYpn3hqM43fggm2pH/ekL+CjRLHisfB811N
	 XWpOU1cPTs2StGkWNOLAR4dS/sD5BN0x0lvUKzvYZaNZlYUS5lIl5ANOi7FUuIHg1z
	 12ngNRgzkbITgqvwBc3J2runbhUWRVH1Bsnhacut/vO46kng0PjYExoLrA45mKzTTU
	 UNss/NqsRfT38DKye54XXfeCUtBHWasSr8uoMGjw2TSbICHO8JbHWfgEdySKTKDkRg
	 3smZZVp7JMr1A==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-896fb37d1f0so97952686d6.2
        for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 11:42:33 -0800 (PST)
X-Gm-Message-State: AOJu0YxiES8PLIJUj4E2HJ43ItvTIzqXQ/KOXHAshkoQ1ojFkfi6Sv7t
	AKtusS6KSMDbdRjojd+9eoBEMy2LyzG2kesmaj5QDQyDb4PcI5hAV4oE/fplmVHxiZdZt8of8Ju
	IY+Le+rUIWjLsYcPGm/aOKSl/gJCGm58=
X-Received: by 2002:a05:6214:518a:b0:890:628c:30fe with SMTP id
 6a1803df08f44-89740483637mr190009076d6.35.1771357352917; Tue, 17 Feb 2026
 11:42:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217160645.3434685-1-joe.lawrence@redhat.com> <20260217160645.3434685-13-joe.lawrence@redhat.com>
In-Reply-To: <20260217160645.3434685-13-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 17 Feb 2026 11:42:21 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4YN5PYp3iF8P3pBGF8vP62m0L-yEfD1pBut6fL+78N2Q@mail.gmail.com>
X-Gm-Features: AaiRm52FZBhudPdIHMzDvhA5DMylsWOdvfX1uaPnGWBZPJu6DmlQiLT4fMax_kU
Message-ID: <CAPhsuW4YN5PYp3iF8P3pBGF8vP62m0L-yEfD1pBut6fL+78N2Q@mail.gmail.com>
Subject: Re: [PATCH v3 12/13] livepatch/klp-build: report patch validation drift
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2042-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CA86114FB3C
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 8:07=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> Capture the output of the patch command to detect when a patch applies
> with fuzz or line offsets.
>
> If such "drift" is detected during the validation phase, warn the user
> and display the details.  This helps identify input patches that may need
> refreshing against the target source tree.
>
> Ensure that internal patch operations (such as those in refresh_patch or
> during the final build phase) can still run quietly.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  scripts/livepatch/klp-build | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index fd104ace29e6..5367d573b94b 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -369,11 +369,24 @@ check_unsupported_patches() {
>
>  apply_patch() {
>         local patch=3D"$1"
> +       shift
> +       local extra_args=3D("$@")
> +       local drift_regex=3D"with fuzz|offset [0-9]+ line"
> +       local output
> +       local status
>
>         [[ ! -f "$patch" ]] && die "$patch doesn't exist"
> -       patch -d "$SRC" -p1 --dry-run --silent --no-backup-if-mismatch -r=
 /dev/null < "$patch"
> -       patch -d "$SRC" -p1 --silent --no-backup-if-mismatch -r /dev/null=
 < "$patch"
> +       status=3D0
> +       output=3D$(patch -d "$SRC" -p1 --dry-run --no-backup-if-mismatch =
-r /dev/null "${extra_args[@]}" < "$patch" 2>&1) || status=3D$?
> +       if [[ "$status" -ne 0 ]]; then
> +               echo "$output"
> +               die "$patch did not apply"
> +       elif [[ "$output" =3D~ $drift_regex ]]; then
> +               warn "$patch applied with drift"
> +               echo "$output"
> +       fi

It appears we only need the non-silent "patch" command and the reporting
logic in validate_patches(). Maybe we can have a different version of
apply_patches for validate_patches(), say apply_patches_verbose(), and
keep existing apply_patch() and apply_patches as-is?

Thanks,
Song

>
> +       patch -d "$SRC" -p1 --no-backup-if-mismatch -r /dev/null "${extra=
_args[@]}" --silent < "$patch"
>         APPLIED_PATCHES+=3D("$patch")
>  }
>
> @@ -392,10 +405,11 @@ revert_patch() {
>  }
>
>  apply_patches() {
> +       local extra_args=3D("$@")
>         local patch
>
>         for patch in "${PATCHES[@]}"; do
> -               apply_patch "$patch"
> +               apply_patch "$patch" "${extra_args[@]}"
>         done
>  }
>
> @@ -453,7 +467,7 @@ refresh_patch() {
>         ( cd "$SRC" && echo "${input_files[@]}" | xargs cp --parents --ta=
rget-directory=3D"$tmpdir/a" )
>
>         # Copy patched source files to 'b'
> -       apply_patch "$patch"
> +       apply_patch "$patch" "--silent"
>         ( cd "$SRC" && echo "${output_files[@]}" | xargs cp --parents --t=
arget-directory=3D"$tmpdir/b" )
>         revert_patch "$patch"
>
> @@ -826,7 +840,7 @@ fi
>  if (( SHORT_CIRCUIT <=3D 2 )); then
>         status "Fixing patch(es)"
>         fix_patches
> -       apply_patches
> +       apply_patches "--silent"
>         status "Building patched kernel"
>         build_kernel "patched"
>         revert_patches
> --
> 2.53.0
>

