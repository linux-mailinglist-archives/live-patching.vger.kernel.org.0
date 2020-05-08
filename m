Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558C81CB41F
	for <lists+live-patching@lfdr.de>; Fri,  8 May 2020 17:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgEHPzY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 8 May 2020 11:55:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37803 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728179AbgEHPzX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 8 May 2020 11:55:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588953322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AEs8yUw7AICa5TgXel8CzNJzF7a92y7CCE6VKa4PeRM=;
        b=U7V3zsMAsSOUUYCL8k4zC809h5KqyhprDfFdsYK2PW3reY3xG33qeTmgFysZysYIsq2VNj
        BzGBFfhsRpyzw8ETV8lir1w87+nUcCAOkb7N/Vacdl6s/EIUc1NeUlXHSQ/oQDcypL7m5u
        Y+JfqMJBbTdsLJIlvHEdOLqI+CRLoeI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-rKKGrZ9AMfCjnCdJvuNSLg-1; Fri, 08 May 2020 11:55:18 -0400
X-MC-Unique: rKKGrZ9AMfCjnCdJvuNSLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AA2A1800D42;
        Fri,  8 May 2020 15:55:17 +0000 (UTC)
Received: from treble (ovpn-115-96.rdu2.redhat.com [10.10.115.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B113D100164D;
        Fri,  8 May 2020 15:55:13 +0000 (UTC)
Date:   Fri, 8 May 2020 10:55:11 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] livepatch: Make klp_apply_object_relocs static
Message-ID: <20200508155511.462d6pnbebcryi2j@treble>
References: <1588939594-58255-1-git-send-email-zou_wei@huawei.com>
 <20200508155335.jyfo4rhdvbyoq5kl@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200508155335.jyfo4rhdvbyoq5kl@treble>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 08, 2020 at 10:53:41AM -0500, Josh Poimboeuf wrote:
> On Fri, May 08, 2020 at 08:06:34PM +0800, Samuel Zou wrote:
> > Fix the following sparse warning:
> > 
> > kernel/livepatch/core.c:748:5: warning: symbol 'klp_apply_object_relocs'
> > was not declared. Should it be static?
> 
> Yes, it should :-)
> 
> So instead of the question, the patch description should probably state
> that it should be static because its only caller is in the file.

... and it probably should also have a Fixes tag which references the
commit which introduced this issue.

> With that change:
> 
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh

