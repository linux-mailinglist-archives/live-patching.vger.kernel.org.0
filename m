Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C0321D651
	for <lists+live-patching@lfdr.de>; Mon, 13 Jul 2020 14:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgGMMvc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Jul 2020 08:51:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40038 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729494AbgGMMvc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Jul 2020 08:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594644690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YjOX0+qMsr0MZ2n7yEIvNR1la6gfCqgxiam2qlcsRPU=;
        b=S9qTjGSy8Xh/EUevtMgzDRA5Vo4caNjV2uga7EwXHJoIpFsi7g4CyD8m35h8gluJr/feDr
        JIWjptrN5JSKyxaqwD/Rws9SjGj2fKNAa8dlK7L7VzlB+wa1In3aLW+tMqDaUPwF5mTRKw
        JrSIrL86jQOmTefW7L+LRMSNZUXSW0A=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-8Mdafo7qOC6Iv2X1W7id_w-1; Mon, 13 Jul 2020 08:51:27 -0400
X-MC-Unique: 8Mdafo7qOC6Iv2X1W7id_w-1
Received: by mail-qv1-f70.google.com with SMTP id j6so7349964qvl.13
        for <live-patching@vger.kernel.org>; Mon, 13 Jul 2020 05:51:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YjOX0+qMsr0MZ2n7yEIvNR1la6gfCqgxiam2qlcsRPU=;
        b=jNUDerFK0kCRlwg3dM00fO83TxOnlQsHguVgB33iZlGvVTOBLRfbzDcm9aPZaLcJ0p
         YoLoiLT7BUvM4Jf0GkTeiGVzeVifjsjx7JVR4tT94QnUDWkWpSd2rl8FZGVwQLf6VwV1
         CC3gArAfQcRVqh1o03yLZJLzwZwq4O1jDlb3AkFxNEPLIa4DA8n4bCvhZYFQJIaS9B3p
         PlqKg/mD75xIooZ69zI9wxdIL6Srw0gGslleihepUHla/d0hkvv6Kj7du97orpFzRiAG
         Yie9lBz3tpGX5hDpukYZc9PfFYKROfYW0pwxtXAul0uj/GUNUSU/hMh6SYjqxn5INXki
         k/1w==
X-Gm-Message-State: AOAM53154/B8pGE1p4wdc5pw71g5gqCYSq6TCPPji81FWKgFTMwhBc9V
        8GEmMZ4XB2qjNVZN8MD657+FZijWNmzOSD4czAVcL4ZdYSnRAmEIut5GKjGdndOhXyduQCbh7Om
        GJCW3bVrk7LtUqpYrpnyb2qONp8Gq7+mGoNkSzFmZ8g==
X-Received: by 2002:a37:5b81:: with SMTP id p123mr79713627qkb.150.1594644686658;
        Mon, 13 Jul 2020 05:51:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxekftooSxa1u1VC3aPSrNHxSTGnX+9e052hcG04Me+8Z6Np01h076NBmbFLdN/2WyjobuC1GlPp9SslA84gNU=
X-Received: by 2002:a37:5b81:: with SMTP id p123mr79713605qkb.150.1594644686341;
 Mon, 13 Jul 2020 05:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200710183745.19730-1-joe.lawrence@redhat.com>
In-Reply-To: <20200710183745.19730-1-joe.lawrence@redhat.com>
From:   Yannick Cote <ycote@redhat.com>
Date:   Mon, 13 Jul 2020 08:51:15 -0400
Message-ID: <CAKMMXfb0kuynAjA76fnB+BWX+wRVY2NQ+hPs4nSJi3YgbEnsew@mail.gmail.com>
Subject: Re: [PATCH] selftests/livepatch: Use "comm" instead of "diff" for dmesg
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jul 10, 2020 at 2:39 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> BusyBox diff doesn't support the GNU diff '--LTYPE-line-format' options
> that were used in the selftests to filter older kernel log messages from
> dmesg output.
>
> Use "comm" which is more available in smaller boot environments.
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>
> based-on: livepatching.git/for-5.9/selftests-cleanup
> merge-thru: livepatching.git
>
>  tools/testing/selftests/livepatch/functions.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
> index 36648ca367c2..408529d94ddb 100644
> --- a/tools/testing/selftests/livepatch/functions.sh
> +++ b/tools/testing/selftests/livepatch/functions.sh
> @@ -277,7 +277,7 @@ function check_result {
>         # help differentiate repeated testing runs.  Remove them with a
>         # post-comparison sed filter.
>
> -       result=$(dmesg | diff --changed-group-format='%>' --unchanged-group-format='' "$SAVED_DMESG" - | \
> +       result=$(dmesg | comm -13 "$SAVED_DMESG" - | \
>                  grep -e 'livepatch:' -e 'test_klp' | \
>                  grep -v '\(tainting\|taints\) kernel' | \
>                  sed 's/^\[[ 0-9.]*\] //')
> --
> 2.21.3
>

Reviewed-by: Yannick Cote <ycote@redhat.com>

