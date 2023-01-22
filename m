Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA562676BA6
	for <lists+live-patching@lfdr.de>; Sun, 22 Jan 2023 09:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjAVIfW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 22 Jan 2023 03:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjAVIfV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 22 Jan 2023 03:35:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D03F18149
        for <live-patching@vger.kernel.org>; Sun, 22 Jan 2023 00:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674376473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LBOy3GEyTxqSKd3pw0Cq7/zzqUVdT2OzA5ZHrT96yhk=;
        b=XO9hxTYufzYz2LW9tVVHXm0d0vBz5uDZqFHw9l3qcROu7tveqkH8XnDVC6bsdh4e6WMK20
        F4pPX+dvg9sygfkv8uCgqSL81hBTRmx9hIEb6UOCbn6dVLZF+8AhTty236iRKAcFuDtmH4
        yQi9+qN7y35GsHR1QkZnodezKXUvo14=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-442-L5K5if0TNbSeqkfZrB_SSQ-1; Sun, 22 Jan 2023 03:34:32 -0500
X-MC-Unique: L5K5if0TNbSeqkfZrB_SSQ-1
Received: by mail-ed1-f71.google.com with SMTP id z18-20020a05640235d200b0049d84165065so6545200edc.18
        for <live-patching@vger.kernel.org>; Sun, 22 Jan 2023 00:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBOy3GEyTxqSKd3pw0Cq7/zzqUVdT2OzA5ZHrT96yhk=;
        b=0ZeJ7r2tPxodv8h5Xx8BCBI10xBC1BKnV/S4n9LIH8nfd6tTla20a8uCwMfhFDv/yJ
         bAt/e2YEc1JRjQpPhODZJHX0JKk5h1ZorjZBlxJ7niM8dUjPBQrdl8miXQRR3NkM1MLu
         gqEYqZSFfpy/sOxv/PRJWLq5XvfZ1l2wfKglzYJ/q57YSH1tfZcphtP1dYklw7y95Q5X
         FT+LLUMbhOGtCNM/Lrrc0BJDY6fsFItBKQhLLSxtPpTskZElxldi0XBeuUcBSW/Men+q
         9D/1k/JGBUKg25/hOueY12lLd8RAJK+lGam9imc2FM2StVshr3xM09X32+8KszN3AxvY
         kxcQ==
X-Gm-Message-State: AFqh2kpGYXte5YK7fFv+YaeFRpoBm/6uZjqgfuIS6rlxW6Xg5/admGxs
        uBbguyKKNf9nG9BdJks6MoCDOlZS2hVs6rRjCkcONmD4G7/lVGmm9JMVFuugl1nKBWHmDwkEHrC
        WuSTiXkQIogT9XgpIOEM/Fw38mw==
X-Received: by 2002:a17:906:d8ad:b0:875:54f5:740d with SMTP id qc13-20020a170906d8ad00b0087554f5740dmr18980182ejb.51.1674376471262;
        Sun, 22 Jan 2023 00:34:31 -0800 (PST)
X-Google-Smtp-Source: AMrXdXupkktggRT0GhSuPRcESSXkQviODPyb9ZmRHAGX+AHHUI13v12MW9XOdnRYvnmjPv5GEmYCQw==
X-Received: by 2002:a17:906:d8ad:b0:875:54f5:740d with SMTP id qc13-20020a170906d8ad00b0087554f5740dmr18980169ejb.51.1674376471041;
        Sun, 22 Jan 2023 00:34:31 -0800 (PST)
Received: from redhat.com ([2.52.149.29])
        by smtp.gmail.com with ESMTPSA id lb19-20020a170907785300b0084d1efe9af6sm20325371ejc.58.2023.01.22.00.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 00:34:30 -0800 (PST)
Date:   Sun, 22 Jan 2023 03:34:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>
Cc:     Petr Mladek <pmladek@suse.com>, Jason Wang <jasowang@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <20230122032944-mutt-send-email-mst@kernel.org>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 20, 2023 at 04:12:20PM -0600, Seth Forshee (DigitalOcean) wrote:
> We've fairly regularaly seen liveptches which cannot transition within kpatch's
> timeout period due to busy vhost worker kthreads. In looking for a solution the
> only answer I found was to call klp_update_patch_state() from a safe location.
> I tried adding this call to vhost_worker(), and it works, but this creates the
> potential for problems if a livepatch attempted to patch vhost_worker().
> Without a call to klp_update_patch_state() fully loaded vhost kthreads can
> never switch because vhost_worker() will always appear on the stack, but with
> the call these kthreads can switch but will still be running the old version of
> vhost_worker().
> 
> To avoid this situation I've added a new function, klp_switch_current(), which
> switches the current task only if its stack does not include any function being
> patched. This allows kthreads to safely attempt switching themselves if a patch
> is pending. There is at least one downside, however. Since there's no way for
> the kthread to track whether it has already tried to switch for a pending patch
> it can end up calling klp_switch_current() repeatedly when it can never be
> safely switched.
> 
> I don't know whether this is the right solution, and I'm happy to try out other
> suggestions. But in my testing these patches proved effective in consistently
> switching heavily loaded vhost kthreads almost immediately.
> 
> To: Josh Poimboeuf <jpoimboe@kernel.org>
> To: Jiri Kosina <jikos@kernel.org>
> To: Miroslav Benes <mbenes@suse.cz>
> To: Petr Mladek <pmladek@suse.com>
> To: Joe Lawrence <joe.lawrence@redhat.com>
> To: "Michael S. Tsirkin" <mst@redhat.com>
> To: Jason Wang <jasowang@redhat.com>
> Cc: live-patching@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>

Don't know enough about live patching to judge this.

I'll let livepatch maintainers judge this, and merge through
the livepatch tree if appropriate. For that:
Acked-by: Michael S. Tsirkin <mst@redhat.com>
but pls underestand this is more a 'looks ok superficially and
I don't have better ideas'  than 'I have reviewed this thoroughly'.

> 
> ---
> Seth Forshee (DigitalOcean) (2):
>       livepatch: add an interface for safely switching kthreads
>       vhost: check for pending livepatches from vhost worker kthreads
> 
>  drivers/vhost/vhost.c         |  4 ++++
>  include/linux/livepatch.h     |  2 ++
>  kernel/livepatch/transition.c | 11 +++++++++++
>  3 files changed, 17 insertions(+)
> ---
> base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
> change-id: 20230120-vhost-klp-switching-ba9a3ae38b8a
> 
> Best regards,
> -- 
> Seth Forshee (DigitalOcean) <sforshee@kernel.org>

