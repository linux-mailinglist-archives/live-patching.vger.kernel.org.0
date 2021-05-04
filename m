Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F60373211
	for <lists+live-patching@lfdr.de>; Tue,  4 May 2021 23:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhEDVyA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 May 2021 17:54:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231756AbhEDVx7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 May 2021 17:53:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620165183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2cQ/IxN1Yroot3xqxYmayP4r/OC/LGm0hr5S1oQiy9w=;
        b=C6wKa0T2XCZSK4TkHy94eA0noXaBCw2uzjxZiiEa3IwC6aQATIT3TsYSsYhf/6i+OQbsXn
        OJ/kmgWdkPuRMdEr1RKmk18BPlI6Nx6GYEkMrn3+sY1RgUu1Ct0X1M+KiOkaZlCcbs/0yn
        qA7J8ggFx7i2gR7biWv7ASmaPsU7MuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-Hvd_BMyoOQOrSJAerVpWCw-1; Tue, 04 May 2021 17:52:59 -0400
X-MC-Unique: Hvd_BMyoOQOrSJAerVpWCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 770FC824FB9;
        Tue,  4 May 2021 21:52:51 +0000 (UTC)
Received: from treble (ovpn-115-93.rdu2.redhat.com [10.10.115.93])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7CAE55C22A;
        Tue,  4 May 2021 21:52:49 +0000 (UTC)
Date:   Tue, 4 May 2021 16:52:48 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/4] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210504215248.oi3zay3memgqri33@treble>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210503173615.21576-2-madvenka@linux.microsoft.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, May 03, 2021 at 12:36:12PM -0500, madvenka@linux.microsoft.com wrote:
> @@ -44,6 +44,8 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>  	unsigned long fp = frame->fp;
>  	struct stack_info info;
>  
> +	frame->reliable = true;
> +

Why set 'reliable' to true on every invocation of unwind_frame()?
Shouldn't it be remembered across frames?

Also, it looks like there are several error scenarios where it returns
-EINVAL but doesn't set 'reliable' to false.

-- 
Josh

