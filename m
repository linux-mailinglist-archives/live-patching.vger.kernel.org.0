Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586333A9682
	for <lists+live-patching@lfdr.de>; Wed, 16 Jun 2021 11:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhFPJxH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Jun 2021 05:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhFPJxG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Jun 2021 05:53:06 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9B5C061574
        for <live-patching@vger.kernel.org>; Wed, 16 Jun 2021 02:51:00 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id v6so1355707qta.9
        for <live-patching@vger.kernel.org>; Wed, 16 Jun 2021 02:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=HQcV8tprGb6VLvGS/5D4mQySFW9nyiml/UQXRFzCAw8=;
        b=nlwwZ19fnOdqAQe55oIqsELSJbElJGiTa5u7fznl0uZlMOKDJPXCn3wTanyQcgiXhI
         4E8AttGoK/UDSiKqhwEHtQ5mSZkyDw0ot9TCnWbjKXtfMRpROdWoSuU9+kR2+vmSmr1S
         /vYU6SjmdyWToR44jRQbRViidqGw4al7VSurUcUbnOF69AvdzwRwBK+cmHLrD4vXdzdf
         4tv02DeHhNQVN/PRRCGMw1kIu8l37zitOkwhlQ6/CO3sSEIrkfv1WB5v9z1DD3SS0ONz
         X7rUqH5MgUmlzYVQ3HmXmF1c/VjmLgqsmcQdscYnX/ONXgG/F1o8ud6/Azy/t7KdDIqD
         ws4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=HQcV8tprGb6VLvGS/5D4mQySFW9nyiml/UQXRFzCAw8=;
        b=TxMmC2OsgfqnoVooxsq1ZcLPHLHvuUiuYlhaZAVh/Yv6ImU/JNYLqKMEPFKzZfDp+J
         vCV3AgkNc2glWm4QCK0ChR/6rAsj0+3gx77FZ86BGMqw/AB28AVYHh5/B3aFgTQomSSd
         8Merlrj5zbfTQmuYHqDcq8S5cKJd5A9WVDKf5zBLtf39bKy7Aea3lWXz0x6nF3Kt7K53
         BS7elSSN9USHYspXyY8zAvPpHUEB7PDi3fNCVhUyGkTOfqWZPlvqqb5QwPAeTEk4Tyxu
         SGPFmva5LDzBc6Q1C5Sb+k3b2tNXmRQD9lcUNtpL79wQuO+zlX9w2ItZkpPWW746r5K7
         F23A==
X-Gm-Message-State: AOAM531jl4GIiygd8CyQYKpGu1shf+ZOZUNFE0J7nPo1G4hpqfJobvoD
        1v7XhWhfCqtb/5YOx+PAIxwy0qqmmOFw4NJk2T4=
X-Google-Smtp-Source: ABdhPJx0UK+Ud+T8WQdfDJhJGXwGIRQQNgsb5RJ0JWBbW5II7exbfvTnWvQ1C56Mk2Yu5wGxC5CHsGxSJ+YJgqv7vM0=
X-Received: by 2002:ac8:6951:: with SMTP id n17mr4280322qtr.340.1623837058698;
 Wed, 16 Jun 2021 02:50:58 -0700 (PDT)
MIME-Version: 1.0
Sender: labosozarrin@gmail.com
Received: by 2002:a0c:fde3:0:0:0:0:0 with HTTP; Wed, 16 Jun 2021 02:50:58
 -0700 (PDT)
From:   Mr Umar khalifa <mrumarkhalifa@gmail.com>
Date:   Wed, 16 Jun 2021 02:50:58 -0700
X-Google-Sender-Auth: axBOxMeD3MxnJzWwN7eElzLdSMw
Message-ID: <CAK-L8TpZrckZPQeiBGCfKTY3Nb2FVdXDYAPx5hvCG-wVsK=mtw@mail.gmail.com>
Subject: =?UTF-8?B?5LqL5qWt5o+Q5qGI?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

5oSb44GZ44KL44OR44O844OI44OK44O8DQoNCuengeOBruWQjeWJjeOBr+OCpuODnuODq+ODu+OD
j+ODquODleOCoeOBleOCk+OBp+OBmeOAgiDnp4Hjga/jg5fjg6njgqTjg6Djg5Djg7Pjgq/jga4x
44Gk44Go5Y2U5Yqb44GX44Gm44GE44G+44GZDQrjg5bjg6vjgq3jg4rjg5XjgqHjgr3jgafjgIIg
44GT44Gu6YqA6KGM44Gr44Gv5aSa44GP44Gu5Lq644Gu5LyR55yg5Y+j5bqn44GM44GC44KK44G+
44GX44GfDQrnp4HjgZ/jgaHjga7mlYXlpJblm73jga7poaflrqLjga4x5Lq644Gr5bGe44GX44Gm
44GE44Gf5bm044CCIOe3j+mhjQ0K44GT44Gu44Ki44Kr44Km44Oz44OI44Gn44GvJCA4LDUwMCww
MDAuMDDvvIg4MDDkuIc1MDDkuIfvvInjgavjgarjgorjgb7jgZkNCuWNg+exs+ODieODq++8ieOA
gg0KDQrpioDooYzjgYzjgZPjga7os4fph5HjgpLpgIHph5HjgZnjgovlpJblm73lj6PluqfjgYzm
rLLjgZfjgYTjga7jgafjgZnjgYzjgIIg56eBDQrnibnjgavjgYvjgonjgZPjga7jg6Hjg4Pjgrvj
g7zjgrjjgpLoqq3jgpPjgafpqZrjgYvjgozjgovjgZPjgajjgpLnn6XjgaPjgabjgYTjgb7jgZkN
CuOBguOBquOBn+OBq+avlOi8g+eahOefpeOCieOCjOOBpuOBhOOBquOBhOiqsOOBi+OAgiDjgZfj
gYvjgZfjgIHjgZ3jgozjgbvjganlv4PphY3jgZfjgarjgYTjgafjgY/jgaDjgZXjgYTjgIINCg0K
44GT44KM44Gv44CB5pys54mp44Gu44CB44Oq44K544Kv44Gu44Gq44GE44CB5ZCI5rOV55qE44Gq
5ZWG5Y+W5byV44Gn44GZ44CCIOW/nOetlA0K6IiI5ZGz44GM44GC44KM44Gw44CB57eK5oCl44Gr
56eB44Gr5oi744Gj44Gm44GP44Gg44GV44GE44CCDQoNCuengeOBjOOBguOBquOBn+OBi+OCieiB
nuOBhOOBn+OCieOAgeOBmeOBueOBpuOBruips+e0sOOBr+OBguOBquOBn+OBq+mAgeOCieOCjOOC
i+OBp+OBl+OCh+OBhuOAgg0KDQrlrpzjgZfjgY/jgYrpoZjjgYTjgZfjgb7jgZnjgIENCg0K44Km
44Oe44Or44O744OP44Oq44OV44Kh5rCPDQouLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uDQoNCkRlYXIgcGFydG5lcg0KDQpN
eSBuYW1lIGlzIE1yIFVtYXIgIGtoYWxpZmEuIEkgYW0gd29ya2luZyB3aXRoIG9uZSBvZiB0aGUg
cHJpbWUgYmFua3MNCmluIEJ1cmtpbmEgRmFzby4gSGVyZSBpbiB0aGlzIGJhbmsgZXhpc3RlZCBh
IGRvcm1hbnQgYWNjb3VudCBmb3IgbWFueQ0KeWVhcnMsIHdoaWNoIGJlbG9uZ2VkIHRvIG9uZSBv
ZiBvdXIgbGF0ZSBmb3JlaWduIGN1c3RvbWVycy4gVGhlIGFtb3VudA0KaW4gdGhpcyBhY2NvdW50
IHN0YW5kcyBhdCAkOCw1MDAsMDAwLjAwIChFaWdodCBNaWxsaW9uIEZpdmUgSHVuZHJlZA0KVGhv
dXNhbmQgVVMgRG9sbGFycykuDQoNCkkgd2FudCBhIGZvcmVpZ24gYWNjb3VudCB3aGVyZSB0aGUg
YmFuayB3aWxsIHRyYW5zZmVyIHRoaXMgZnVuZC4gSQ0Ka25vdyB5b3Ugd291bGQgYmUgc3VycHJp
c2VkIHRvIHJlYWQgdGhpcyBtZXNzYWdlLCBlc3BlY2lhbGx5IGZyb20NCnNvbWVvbmUgcmVsYXRp
dmVseSB1bmtub3duIHRvIHlvdS4gQnV0LCBkbyBub3Qgd29ycnkgeW91cnNlbGYgc28gbXVjaC4N
Cg0KVGhpcyBpcyBhIGdlbnVpbmUsIHJpc2sgZnJlZSBhbmQgbGVnYWwgYnVzaW5lc3MgdHJhbnNh
Y3Rpb24uIFJlcGx5DQpiYWNrIHRvIG1lIHVyZ2VudGx5LCBpZiB5b3UgYXJlIGludGVyZXN0ZWQu
DQoNCkFsbCBkZXRhaWxzIHNoYWxsIGJlIHNlbnQgdG8geW91IG9uY2UgSSBoZWFyIGZyb20geW91
Lg0KDQpCZXN0IHJlZ2FyZHMsDQoNCk1yIFVtYXIga2hhbGlmYQ0K
