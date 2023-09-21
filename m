Return-Path: <live-patching+bounces-5-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 411897A9AC0
	for <lists+live-patching@lfdr.de>; Thu, 21 Sep 2023 20:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C21682822DA
	for <lists+live-patching@lfdr.de>; Thu, 21 Sep 2023 18:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C232F168DB;
	Thu, 21 Sep 2023 17:49:22 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8402E18AE5
	for <live-patching@vger.kernel.org>; Thu, 21 Sep 2023 17:49:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDA389D99
	for <live-patching@vger.kernel.org>; Thu, 21 Sep 2023 10:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695318020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=64XIT8H+cirzJrInDt0c0EtJPFaDtKDsNwOF41i1jT8=;
	b=Tu23uBe1dwpVamupAu2otnTr9y675MxBkbZTZkptaI20CsZjIjcMGlg2ACHlL7zktCOHAb
	CvAUiBF5nty6G3ekr/8d+EJDGVX4WWSLjUJexbc8gDZcMEIpZTUP4o7KbP03339zs79hiy
	2ST43OvWHBKPJgf08jkHjubUFTHCdAw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149--qQOOeIeOsG2h6U8QW0EDw-1; Thu, 21 Sep 2023 09:22:50 -0400
X-MC-Unique: -qQOOeIeOsG2h6U8QW0EDw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7740c8048bbso32645485a.0
        for <live-patching@vger.kernel.org>; Thu, 21 Sep 2023 06:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695302569; x=1695907369;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=64XIT8H+cirzJrInDt0c0EtJPFaDtKDsNwOF41i1jT8=;
        b=h7FuDH57bO0sTJCGSkgb/5kI3fhzeiFLeVeMhT1l7qumUywh7bCAwSVF1/H+uK6TUG
         s17JH3xi+BR4DyJFdgAY5LQt2P1ArbG4ikrYoZGgpj0IkdPTyrtr3POYuIh8Du11losC
         AgyC49vPKdf1BR2wbKe7RsN4uwHK1DxeDVO7kuT/rkza7B233gWdMEsT2nLUiNIDN6S6
         AhsXOF1JYJXZJuHOU32gMA6FDc9EQy1w0KYSVZSW9rAOO4ZGpdPZfgEop+w9RDgSRwc+
         sNj84NA4Px1v/ymkk1bnXMvFaxEz4Ld4lfKeuPqOP1hezn4mInZM7c6kfLbuc3+oXxdV
         H8pQ==
X-Gm-Message-State: AOJu0Yx6rbmyFIY0xSehh9IxymGD8bmK8jGvOpYaPqXOAB64V4KJFrxa
	PCxH6vmlaPr8I6ssdEYcmdgm4JGj867DtmehfZYoHquCBbsvkF0YGjWiDhKiq9I8I0FKTfJu5kb
	0US6oEHVrLN1tY10+/o2HaWfzbg==
X-Received: by 2002:a05:620a:bd6:b0:773:a91c:6164 with SMTP id s22-20020a05620a0bd600b00773a91c6164mr10167267qki.19.1695302569770;
        Thu, 21 Sep 2023 06:22:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOAVkieqa7avECMyCd3R5BOjdreLXm1gXdIE81QoNHp+hCn2/S9LgxfK3ML1R3gd61F/wEbA==
X-Received: by 2002:a05:620a:bd6:b0:773:a91c:6164 with SMTP id s22-20020a05620a0bd600b00773a91c6164mr10167245qki.19.1695302569471;
        Thu, 21 Sep 2023 06:22:49 -0700 (PDT)
Received: from [192.168.1.12] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id 11-20020ac8564b000000b003f6ac526568sm607991qtt.39.2023.09.21.06.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 06:22:48 -0700 (PDT)
Message-ID: <77033ba0-9786-62c6-d3fd-ad1226017c09@redhat.com>
Date: Thu, 21 Sep 2023 09:22:47 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: Recent Power changes and stack_trace_save_tsk_reliable?
Content-Language: en-US
To: Michael Ellerman <mpe@ellerman.id.au>, Petr Mladek <pmladek@suse.com>
Cc: linuxppc-dev@lists.ozlabs.org, live-patching@vger.kernel.org,
 Ryan Sullivan <rysulliv@redhat.com>, Nicholas Piggin <npiggin@gmail.com>
References: <ZO4K6hflM/arMjse@redhat.com> <87o7ipxtdc.fsf@mail.lhotse>
 <87il8xxcg7.fsf@mail.lhotse>
 <cca0770c-1510-3a02-d0ba-82ee5a0ae4f2@redhat.com> <ZQr-vmBBQ66TRobQ@alley>
 <8734z7ogpd.fsf@mail.lhotse>
From: Joe Lawrence <joe.lawrence@redhat.com>
In-Reply-To: <8734z7ogpd.fsf@mail.lhotse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_NONE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 9/21/23 08:26, Michael Ellerman wrote:
> Petr Mladek <pmladek@suse.com> writes:
>> On Wed 2023-08-30 17:47:35, Joe Lawrence wrote:
>>> On 8/30/23 02:37, Michael Ellerman wrote:
>>>> Michael Ellerman <mpe@ellerman.id.au> writes:
>>>>> Joe Lawrence <joe.lawrence@redhat.com> writes:
>>>>>> We noticed that our kpatch integration tests started failing on ppc64le
>>>>>> when targeting the upstream v6.4 kernel, and then confirmed that the
>>>>>> in-tree livepatching kselftests similarly fail, too.  From the kselftest
>>>>>> results, it appears that livepatch transitions are no longer completing.
> ...
>>>>
>>>> The diff below fixes it for me, can you test that on your setup?
>>>>
>>>
>>> Thanks for the fast triage of this one.  The proposed fix works well on
>>> our setup.  I have yet to try the kpatch integration tests with this,
>>> but I can verify that all of the kernel livepatching kselftests now
>>> happily run.
>>
>> Have this been somehow handled, please? I do not see the proposed
>> change in linux-next as of now.
> 
> I thought I was waiting for Joe to run the kpatch integration tests, but
> in hindsight maybe he was hinting that someone else should run them (ie. me) ;)
> 
> Patch incoming.

Ah sorry for the confusion.  kpatch integration tests - that's on me.
If kernel stack unwinding is fixed, I'm pretty confident they will
execute.  I will kick them off today, but don't let that hold up the
kernel patches.

Thanks,
-- 
Joe


