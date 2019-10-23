Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868E9E24FF
	for <lists+live-patching@lfdr.de>; Wed, 23 Oct 2019 23:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732586AbfJWVPo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 23 Oct 2019 17:15:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34805 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406074AbfJWVPn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 23 Oct 2019 17:15:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571865341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jFKJV2s+bqZnJXR7hB445Zevjz0xMvRNh+0riasEM+0=;
        b=X++u6S1WQ1RoYFGHRZ2r8UB+lgOW7qJiSIfjSLQY68+U2n74Vty0gvLciQH1Vm2kslksMd
        rzmF8Sm0lBotjE5/Xwv9xXIS98DehTcbmEcn8AWhJHq5O3PvvWYTBmROtJjXfgUnT5mBap
        ckV2qfkxTf+4LMHJy2Z603fQLT9YRtg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-pjhd7Cr8P72pc380zm9iXQ-1; Wed, 23 Oct 2019 17:15:38 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D9A71005509;
        Wed, 23 Oct 2019 21:15:36 +0000 (UTC)
Received: from treble (ovpn-121-225.rdu2.redhat.com [10.10.121.225])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 471225C1D4;
        Wed, 23 Oct 2019 21:15:31 +0000 (UTC)
Date:   Wed, 23 Oct 2019 16:15:28 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] livepatch: Allow to distinguish different version
 of system state changes
Message-ID: <20191023211528.nfstzbuzzxsyffqh@treble>
References: <20191003090137.6874-1-pmladek@suse.com>
 <20191003090137.6874-4-pmladek@suse.com>
MIME-Version: 1.0
In-Reply-To: <20191003090137.6874-4-pmladek@suse.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: pjhd7Cr8P72pc380zm9iXQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

Sorry for taking so long...

On Thu, Oct 03, 2019 at 11:01:35AM +0200, Petr Mladek wrote:
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 726947338fd5..42907c4a0ce8 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -133,10 +133,12 @@ struct klp_object {
>  /**
>   * struct klp_state - state of the system modified by the livepatch
>   * @id:=09=09system state identifier (non-zero)
> + * @version:=09version of the change (non-zero)

Is it necessary to assume that 'version' is non-zero?  It would be easy
for a user to not realize that and start with version 0.  Then the patch
state would be silently ignored.

I have the same concern about 'id', but I guess at least one of them has
to be non-zero to differentiate valid entries from the array terminator.

> +/* Check if the patch is able to deal with the given system state. */
> +static bool klp_is_state_compatible(struct klp_patch *patch,
> +=09=09=09=09    struct klp_state *state)
> +{
> +=09struct klp_state *new_state;
> +
> +=09new_state =3D klp_get_state(patch, state->id);
> +
> +=09if (new_state)
> +=09=09return new_state->version >=3D state->version;
> +
> +=09/* Cumulative livepatch must handle all already modified states. */
> +=09return !patch->replace;
> +}

From my perspective I view '!new_state' as an error condition.  I'd find
it easier to read if the ordering were changed to check for the error
first:

=09if (!new_state) {
=09=09/*
=09=09 * A cumulative livepatch must handle all already
=09=09 * modified states.
=09=09 */
=09=09return !patch->replace;
=09}

=09return new_state->version >=3D state->version;


> +
> +/*
> + * Check that the new livepatch will not break the existing system state=
s.
> + * Cumulative patches must handle all already modified states.
> + * Non-cumulative patches can touch already modified states.
> + */
> +bool klp_is_patch_compatible(struct klp_patch *patch)
> +{
> +=09struct klp_patch *old_patch;
> +=09struct klp_state *state;
> +
> +
> +=09klp_for_each_patch(old_patch) {

Extra newline above.

> +=09=09klp_for_each_state(old_patch, state) {
> +=09=09=09if (!klp_is_state_compatible(patch, state))
> +=09=09=09=09return false;
> +=09=09}
> +=09}

I think renaming 'state' to 'old_state' would make the intention a
little clearer, and would be consistent with 'old_patch'.

--=20
Josh

